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
    
    let cellIdentifier = "Cell"
    var pullRequest: GitHubPullRequest?
    var files = [GitHubPullRequestFile]()
    let cache = NSCache<NSNumber, FileTableViewCell>()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Received memory warning")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationItems()
        prepareActivityIndicatorView()
        prepareTableView()
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
        activityIndicatorView.centerInParent()
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
        GitHubClient.files(pullRequest) { (files, error) in
            guard let files = files else {
                return
            }
            self.files = files
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicatorView.stopAnimating()
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->  UITableViewCell {
        
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
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DiffController: UITableViewDataSourcePrefetching {
    
    fileprivate func loadCell(_ indexPath: IndexPath) {
        let cacheKey = NSNumber(value: indexPath.section)
        if cache.object(forKey: cacheKey) == nil, let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FileTableViewCell  {

            let file = files[indexPath.section]
            
            DispatchQueue.global(qos: .background).async {
                print("🙊 Prefetching \(file.name)")
                DispatchQueue.main.async {
                    cell.prepare(file)
                    self.cache.setObject(cell, forKey: cacheKey)
                }
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
            loadCell(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
        indexPaths.forEach { (indexPath) in
            print("🙊 Cancelling prefetch \(indexPath)") // No network calls so let it run
        }
    }
}
