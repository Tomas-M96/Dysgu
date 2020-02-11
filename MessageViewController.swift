//
//  MessageViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 29/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    let alertService = AlertService()
    let networkingService = NetworkingService()
    let defaults = UserDefaults.standard
    
    var conversation: Conversation?
    var messages = [Messages]()
    
    var messageId: String?
    
    @IBOutlet weak var messageTable: UITableView!
    @IBOutlet weak var sendField: UITextField!
    
    func getMessages() {
        if let conversationId = conversation?.ConversationID {
            networkingService.response(endpoint: "/messages/" + conversationId, method: "GET") { (result: Result<[Messages], Error>) in
                switch result {
                    case .success(let decodedJSON):
                        self.messages = decodedJSON
                        self.messageTable.reloadData()
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    func clearText() {
        sendField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        messageTable.reloadData()
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        sendMessage()
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
        
        
        let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
        if indexPath.row == lastRowIndex - 1 {
            messageId = messages[indexPath.row].MessageID
            print(messageId)
        }
        
        return cell
    }
  

    
    func sendMessage() {
        
        guard let content = sendField.text,
              let username = defaults.string(forKey: "Username"),
              let myProfileId = defaults.string(forKey: "ProfileId"),
              let recipientId = conversation?.RecipientID,
              let profileId = conversation?.ProfileID
              else { return }
        
        let parametersPOST = ["content": content,
                              "username": username]
        
        let parametersPATCH = ["profileId": profileId,
                               "recipientId": recipientId]
        
        if let conversationId = conversation?.ConversationID {
            networkingService.request(endpoint: "/messages/" + conversationId + "/" + messageId!, method: "POST", parameters: parametersPOST) { (result: Result<Response, Error>) in
                switch result {
                    case .success(let decodedJSON):
                        print("a")
                    case .failure(let error):
                        let alert = self.alertService.alert(message: error.localizedDescription)
                        self.present(alert, animated: true)
                        //self.clearText()
                    print(error)
                }
            }
        }
        
        if conversation?.RecipientID == myProfileId {
            if let conversationId = conversation?.ConversationID {
                networkingService.request(endpoint: "/messages/" + conversationId, method: "PATCH", parameters: parametersPATCH) { (result: Result<Response, Error>) in
                    switch result {
                        case .success(let decodedJSON):
                            print(decodedJSON)
                            //self.dismiss(animated: true, completion: nil)
                        case .failure(let error):
                            let alert = self.alertService.alert(message: error.localizedDescription)
                            self.present(alert, animated: true)
                            //self.clearText()
                        print(error)
                    }
                }
            }
        }
        getMessages()
        clearText()
    }
}
