//
//  GroupViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 04/02/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let alertService = AlertService()
    let networkingService = NetworkingService()
    let defaults = UserDefaults.standard
    
    var hasJoined = Bool()
    var isAdmin = Bool()
    var group: Group?
    var messages = [FeedMessage]()
    @IBOutlet weak var aboutText: UITextView!
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var feedTable: UITableView!
    
    @IBOutlet weak var actionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGroupFeed()
        if (hasJoined) {
            actionButton.setTitle("Leave Group", for: .normal)
            actionButton.backgroundColor = .systemRed
        }else{
            actionButton.setTitle("Join Group", for: .normal)
            actionButton.backgroundColor = .systemOrange
        }
        
        if (isAdmin) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editSegue))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.aboutText.text = group?.About
        feedTable.reloadData()
    }
    
    @objc func editSegue() {}
    
    @IBAction func actionPressed(_ sender: Any) {
        actionGroup()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Message", for: indexPath)
        let message = messages[indexPath.row]
        cell.textLabel?.text = message.Username
        cell.detailTextLabel?.text = message.Content
        return cell
    }
    
    func actionGroup() {
        if let profileId = defaults.string(forKey: "ProfileId") {
            if let groupId = group?.GroupID {
                if (hasJoined) {
                    networkingService.response(endpoint: "/groups/" + groupId + "/" + profileId, method: "DELETE") { (result: Result<Response, Error>) in
                        switch result {
                            case .success(let decodedJSON):
                                print(decodedJSON)
                            case .failure(let error):
                                print(error)
                        }
                    }
                }else{
                    networkingService.request(endpoint: "/groups/" + groupId + "/" + profileId, method: "POST", parameters: ["IsAdmin": 0] ) { (result: Result<Response, Error>) in
                        switch result {
                            case .success(let decodedJSON):
                                print(decodedJSON)
                            case .failure(let error):
                                print(error)
                        }
                    }
                }
            }
        }
    }
    
    func getGroupFeed() {
        if let groupId = group?.GroupID {
            networkingService.response(endpoint: "/" + groupId + "/feed", method: "GET") { (result: Result<[FeedMessage], Error>) in
                switch result {
                    case .success(let decodedJSON):
                        self.messages = decodedJSON
                        print(decodedJSON)
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
}
