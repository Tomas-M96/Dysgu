//
//  MessagesViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 26/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    

    let alertService = AlertService()
    let networkingService = NetworkingService()
    let defaults = UserDefaults.standard
    
    var conversations = [Conversation]()
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var messagesTable: UITableView!
    
    func getConversations() {
        if let profileId = defaults.string(forKey: "ProfileId") {
            networkingService.response(endpoint: "/messages/" + profileId + "/recieved", method: "GET") { (result: Result<[Conversation], Error>) in
                switch result {
                case .success(let decodedJSON):
                    self.conversations = decodedJSON
                    print(self.conversations)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getConversations()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Compose", style: .plain, target: self, action: #selector(composeMessage))
    }
    
    @objc func composeMessage() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        messagesTable.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Conversation", for: indexPath)
        let conversation = conversations[indexPath.row]
        cell.textLabel?.text = "From: " + conversation.Username
        cell.detailTextLabel?.text = "Subject: " + conversation.Header
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
               if let vc = storyboard?.instantiateViewController(withIdentifier: "Message") as?
                   MessageViewController{
                       vc.conversation = conversations[indexPath.row]
                       navigationController?.pushViewController(vc, animated: true)
        }
    }
}
