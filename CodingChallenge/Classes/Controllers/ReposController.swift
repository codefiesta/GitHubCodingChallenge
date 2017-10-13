//
//  ReposController.swift
//  CodingChallenge
//
//  Created by Kevin McKee on 10/11/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import GitHub

class ReposController: UITableViewController {
    
    let cellIdentifier = "Cell"
    var user: GitHubUser?
    var repos = [GitHubRepo]()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationItems()
        prepareTableView()
        prepareData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard !repos.isEmpty else {
            return
        }
        
        if let controller = segue.destination as? PullsController,
            let selectedIndexPath = tableView.indexPathForSelectedRow {
            controller.repo = repos[selectedIndexPath.row]
        }
    }

    fileprivate func prepareTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView()
    }

    fileprivate func prepareData() {
        
        guard let user = user else {
            return
        }
        title = user.login
        tableView.refreshControl?.beginRefreshing()
        GitHubClient.repos(user) { (repos, error) in
            guard let repos = repos else {
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                }
                return
            }
            self.repos = repos
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
            
            if repos.isEmpty {
                self.handleNoRepos()
            }
        }
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        prepareData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        guard !repos.isEmpty else {
            return 0
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !repos.isEmpty else {
            return 0
        }
        return repos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->  UITableViewCell {
        guard !repos.isEmpty, let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RepoTableViewCell else {
            return UITableViewCell()
        }
        
        let repo = repos[indexPath.row]
        cell.nameLabel?.text = repo.name
        cell.descLabel?.text = repo.description
        
        if let language = repo.language {
            cell.languageCodeView?.backgroundColor = ProgrammingLanguage(rawValue: language)?.color ?? UIColor.lightGray
        }
        cell.languageLabel?.text = repo.language
        cell.starGazersLabel?.text = "⭐️ \(repo.starGazers)"
        cell.forksLabel?.text = "⑂ \(repo.forks)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ReposController {
    
    fileprivate func handleNoRepos() {
        
        let message = "\(user?.login ?? "This user") has no repositories to view."
        
        let alert = UIAlertController(title: "No Repos", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            self.navigationController?.popViewController(animated: true)
        }))
        
        
        present(alert, animated: true, completion: nil)
        
    }
}


