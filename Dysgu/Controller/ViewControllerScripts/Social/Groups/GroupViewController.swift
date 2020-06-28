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
    var isAdmin = true
    var group: Group?
    var messages = [FeedMessage]()
    @IBOutlet weak var aboutText: UITextView!
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var feedTable: UITableView!
    
    @IBOutlet weak var actionButton: UIButton!
    
    func getGroup() {
        if let groupId = group?.GroupID {
            networkingService.response(endpoint: "/groups/14", method: "GET") { (result: Result<Group, Error>) in
                switch result {
                    case .success(let decodedJSON):
                        self.group = decodedJSON
                        self.viewSetup()
                        print(decodedJSON)
                    case .failure(let error):
                        print(error)
                }
            }
        }
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
            networkingService.response(endpoint: "/14/feed", method: "GET") { (result: Result<[FeedMessage], Error>) in
                switch result {
                    case .success(let decodedJSON):
                        self.messages = decodedJSON
                        self.feedTable.reloadData()
                    case .failure(let error):
                        print(error)
                }
            }
    }

    func viewSetup() {
        navigationItem.title = group?.Name
        aboutText.text = group?.About
        groupImage.image = UIImage(named: group?.Image ?? "dragon2.png")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGroup()
        getGroupFeed()
        /*
        if (hasJoined) {
            actionButton.setTitle("Leave Group", for: .normal)
            actionButton.backgroundColor = .systemRed
        }else{
            actionButton.setTitle("Join Group", for: .normal)
            actionButton.backgroundColor = .systemOrange
        }*/
        
        if (isAdmin) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editSegue))
        }
    }
    


    override func viewDidAppear(_ animated: Bool) {
        //self.aboutText.text = group?.About
        //feedTable.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getGroup()
        getGroupFeed()
        //feedTable.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "membersSegue" {
            if let vc = segue.destination as? GroupMembersViewController {
                vc.group = group
            }
        }
    }
    
    @objc func editSegue() {
        /*
        if let vc = storyboard?.instantiateViewController(withIdentifier: "GroupAdmin") as? GroupAdminViewController{
            vc.group = group
            navigationController?.pushViewController(vc, animated: true)
        }*/
        performSegue(withIdentifier: "stuffnow", sender: self)
    }
    
    @IBAction func actionPressed(_ sender: Any) {
        //actionGroup()
        let alert = self.alertService.alert(message: "Group Joined")
        self.present(alert, animated: true)
    }
    
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "News", for: indexPath)
        let message = messages[indexPath.row]
        cell.textLabel?.text = message.Username
        cell.detailTextLabel?.text = message.Content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defaults.set(messages[indexPath.row].GroupFeedID, forKey: "FeedId")
        performSegue(withIdentifier: "feedSegue", sender: self)
    }
}
