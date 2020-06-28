//
//  GroupFeedTableViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 14/05/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class GroupFeedTableViewController: UITableViewController {

    let alertService = AlertService()
    let networkingService = NetworkingService()
    let defaults = UserDefaults.standard
    var messages = [FeedMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Compose", style: .plain, target: self, action: #selector(composeMessage))
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "plus.circle.fill")
        getGroupFeed()
    }
    
    @objc func composeMessage() {
        performSegue(withIdentifier: "composeSegue", sender: self)
    }
    
    func getGroupFeed() {
            networkingService.response(endpoint: "/14/feed", method: "GET") { (result: Result<[FeedMessage], Error>) in
                switch result {
                    case .success(let decodedJSON):
                        self.messages = decodedJSON
                        self.tableView.reloadData()
                    case .failure(let error):
                        print(error)
                }
            }
    }
    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "News", for: indexPath)
        let message = messages[indexPath.row]
        cell.textLabel?.text = message.Username
        cell.detailTextLabel?.text = message.Content
        return cell
    }
}
