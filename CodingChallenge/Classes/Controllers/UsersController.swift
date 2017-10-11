//
//  UsersController.swift
//  GitHub
//
//  Created by Kevin McKee on 10/11/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import UIKit
import GitHub

class UsersController: UITableViewController {

    let cellIdentifier = "Cell"
    var results: GitHubSearchResults?
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    fileprivate func prepareData() {
        GitHubClient.users(query: "CosmicMind") { (results, error) in
            guard let results = results else {
                return
            }
            self.results = results
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        guard let results = results else {
            return cell
        }
        
        let user = results.users[indexPath.row]
        cell.textLabel?.text = user.login
        cell.detailTextLabel?.text = user.reposUrl
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

