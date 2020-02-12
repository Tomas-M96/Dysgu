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
    
    var conversationsRecieved = [Conversation]()
    var conversationsSent = [Conversation]()
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var messagesTable: UITableView!
    
    func getRecievedConversations() {
        if let profileId = defaults.string(forKey: "ProfileId") {
            networkingService.response(endpoint: "/messages/" + profileId + "/recieved", method: "GET") { (result: Result<[Conversation], Error>) in
                switch result {
                case .success(let decodedJSON):
                    self.conversationsRecieved = decodedJSON
                    print(self.conversationsRecieved)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getSentConversations() {
        if let profileId = defaults.string(forKey: "ProfileId") {
            networkingService.response(endpoint: "/messages/" + profileId + "/sent", method: "GET") { (result: Result<[Conversation], Error>) in
                switch result {
                case .success(let decodedJSON):
                    self.conversationsSent = decodedJSON
                    print(self.conversationsSent)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRecievedConversations()
        getSentConversations()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Compose", style: .plain, target: self, action: #selector(composeMessage))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getRecievedConversations()
        getSentConversations()
        messagesTable.reloadData()
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        messagesTable.reloadData()
    }
    
    @objc func composeMessage() {
        performSegue(withIdentifier: "composeSegue", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        messagesTable.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (segmentControl.selectedSegmentIndex == 1) {
            return conversationsSent.count
        }else{
            return conversationsRecieved.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (segmentControl.selectedSegmentIndex == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Conversation", for: indexPath)
            let conversation = conversationsSent[indexPath.row]
            cell.textLabel?.text = "From: " + conversation.Username
            cell.detailTextLabel?.text = "Subject: " + conversation.Header
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Conversation", for: indexPath)
            let conversation = conversationsRecieved[indexPath.row]
            cell.textLabel?.text = "From: " + conversation.Username
            cell.detailTextLabel?.text = "Subject: " + conversation.Header
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
               
        if (segmentControl.selectedSegmentIndex == 1) {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "messageView") as?
                       MessageViewController{
                           vc.conversation = conversationsSent[indexPath.row]
                           navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            if let vc = storyboard?.instantiateViewController(withIdentifier: "messageView") as?
                       MessageViewController{
                           vc.conversation = conversationsRecieved[indexPath.row]
                           navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
