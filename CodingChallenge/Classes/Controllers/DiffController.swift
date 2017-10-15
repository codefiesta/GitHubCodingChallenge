//
//  DiffController.swift
//  CodingChallenge
//
//  Created by Kevin McKee on 10/11/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import GitHub

class DiffController: UITableViewController {
    
    var activityIndicatorView: UIActivityIndicatorView!
    
    let maxCellsLoading: Int = 3
    let cellIdentifier = "Cell"
    var pullRequest: GitHubPullRequest?
    var queue = [IndexPath: Bool]()
    var files = [GitHubPullRequestFile]()
    let cache = NSCache<NSNumber, FileTableViewCell>()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("🙀 Received memory warning")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationItems()
        prepareActivityIndicatorView()
        prepareTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cache.removeAllObjects()
    }
    
    fileprivate func prepareActivityIndicatorView() {
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicatorView)
        view.bringSubview(toFront: activityIndicatorView)
        activityIndicatorView.center()
    }

    fileprivate func prepareTableView() {
        tableView.prefetchDataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView()
        tableView.register(FileTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    fileprivate func prepareData() {
        
        guard let pullRequest = pullRequest else {
            return
        }
        
        title = "#\(pullRequest.number)"
        
        activityIndicatorView.startAnimating()
        
        DispatchQueue.global(qos: .background).async {
            
            GitHubClient.files(pullRequest) { (data, error) in
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.activityIndicatorView.stopAnimating()
                        self.dataError()
                    }
                    return
                }
                self.queue.removeAll()
                self.files = data
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.activityIndicatorView.stopAnimating()
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        guard !files.isEmpty else {
            return 0
        }
        return files.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let file = files[section]
        return "\(file.name) +\(file.additions) -\(file.deletions)"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !files.isEmpty else {
            return 0
        }
        return 1
    }

//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->  UITableViewCell {
        
        print("🎉 Cell for row at \(indexPath)")

        let cacheKey = NSNumber(value: indexPath.section)
        if let cell = cache.object(forKey: cacheKey) {
            print("🐙 Found cached cell \(indexPath)")
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FileTableViewCell,
            !files.isEmpty else {
            return UITableViewCell()
        }
        
        // Use the indexPath.section instead of row since I am building section headers for each file
        let file = files[indexPath.section]
        cell.prepare(file)
        cache.setObject(cell, forKey: cacheKey)
        print("🎉 Finished cell")

        return cell
    }
}

extension DiffController: UITableViewDataSourcePrefetching {
    
    fileprivate func createCell(_ indexPath: IndexPath) {
        let cacheKey = NSNumber(value: indexPath.section)
        
        if cache.object(forKey: cacheKey) == nil, let _ = queue[indexPath] {

            let file = files[indexPath.section]
            print("🙊 Prefetching \(file.name)")
            DispatchQueue.main.async {
                guard let cell = self.tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? FileTableViewCell else {
                    return
                }
                cell.prepare(file)
                self.cache.setObject(cell, forKey: cacheKey)
                self.queue.removeValue(forKey: indexPath)
            }
        } else {
            print("🦄 Already cached")
        }
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        guard !files.isEmpty else {
            return
        }
        
        indexPaths.forEach { (indexPath) in
            DispatchQueue.global(qos: .background).async {
                self.queue[indexPath] = true
                self.createCell(indexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
        indexPaths.forEach { (indexPath) in
            DispatchQueue.global(qos: .background).async {
                print("🙊 Cancelling prefetch \(indexPath)")
                self.queue.removeValue(forKey: indexPath)
            }
        }
    }
}

extension DiffController {
    
    fileprivate func dataError() {
        let title = "API Error"
        let message = "Oops. The request may have timed out. Try again?"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            self.prepareData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction) -> Void in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
}
