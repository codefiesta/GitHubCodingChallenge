//
//  UsersController.swift
//  GitHub
//
//  Created by Kevin McKee on 10/11/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import GitHub

enum SearchError: Error {
    case emptyText
    case noResults
}

class UsersController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar?
    
    let cellIdentifier = "Cell"
    var results: GitHubSearchResults?
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationItems()
        prepareSearchBar()
        prepareTableView()
        prepareData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let results = results else {
            return
        }
        
        if let controller = segue.destination as? ReposController,
            let selectedIndexPath = tableView.indexPathForSelectedRow {
            controller.user = results.users[selectedIndexPath.row]
        }
    }
    
    fileprivate func prepareSearchBar() {
        searchBar?.text = "Google"
        searchBar?.enableCancelKeyAccessory()
    }
    
    fileprivate func prepareTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        tableView.tableFooterView = UIView()
    }

    fileprivate func prepareData() {
        
        guard let query = searchBar?.text else {
            return
        }
        
        tableView.refreshControl?.beginRefreshing()
        GitHubClient.users(query: query) { (results, error) in
            guard let results = results, !results.users.isEmpty else {
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    self.handleSearchError(.noResults)
                }
                return
            }
            self.results = results
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()                
            }
        }
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        prepareData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let _ = results else {
            return 0
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let results = results else {
            return 0
        }
        return results.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->  UITableViewCell {
        guard let results = results, let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BasicTableViewCell else {
            return UITableViewCell()
        }
        
        let user = results.users[indexPath.row]
        
        cell.primaryImageView?.image(fromUrl: user.avatarUrl, nil)
        cell.titleLabel?.text = user.login
        cell.descLabel?.text = user.reposUrl
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let backgroundColor: UIColor = (indexPath.row % 2 == 0) ? UIColor.white : UIColor.gray.withAlphaComponent(0.05)
        cell.backgroundColor = backgroundColor
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UsersController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let text = searchBar.text, !text.isEmpty else {
            handleSearchError(.emptyText)
            return
        }
        
        prepareData()
    }
}

extension UsersController {
    
    fileprivate func handleSearchError(_ error: SearchError) {
        let title = "Search Error"
        var message = "Please enter the name of a GitHub user. For example 'MagicalPanda'"

        switch error {
        case .emptyText:
            break
        case .noResults:
            message = "No results found for '\(searchBar?.text ?? "")'"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
        }))
        present(alert, animated: true, completion: nil)
    }
}
