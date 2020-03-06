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
    
    
    func sendMessage(parametersPOST: [String: String], parametersPATCH: [String: String], myProfileId: String) {
        //POSTing a new message to the conversation
        if let conversationId = conversation?.ConversationID {
             networkingService.request(endpoint: "/messages/" + conversationId + "/" + messageId!, method: "POST", parameters: parametersPOST) { (result: Result<Response, Error>) in
                 switch result {
                     case .success(_):
                         print("message sent")
                     case .failure(let error):
                         let alert = self.alertService.alert(message: error.localizedDescription)
                         self.present(alert, animated: true)
                         //self.clearText()
                     print(error)
                 }
             }
         }
         
        //PATCHing the existing conversation to update recipient
         if conversation?.RecipientID == myProfileId {
             if let conversationId = conversation?.ConversationID {
                 networkingService.request(endpoint: "/messages/" + conversationId, method: "PATCH", parameters: parametersPATCH) { (result: Result<Response, Error>) in
                     switch result {
                         case .success(let decodedJSON):
                             print(decodedJSON)
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
        sendField.text = ""
     }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMessages()
        
        /*
        if conversation?.ProfileID == defaults.string(forKey: "ProfileId") {
            navigationItem.title = conversation?.RecipientID
        }*/
        
        messageTable.register(MessageChatCell.self, forCellReuseIdentifier: "message")
        messageTable.separatorStyle = .none
        messageTable.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        NotificationCenter.default  .addObserver(self, selector: #selector(MessageViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default  .addObserver(self, selector: #selector(MessageViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupHideKeyboardOnTap()
    }
    
    func setupHideKeyboardOnTap() {
        self.messageTable.addGestureRecognizer(self.endEditingRecogniser())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecogniser())
    }
    
    func endEditingRecogniser() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = keyboardSize.cgRectValue
        
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardFrame.height
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = keyboardSize.cgRectValue
        
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y += keyboardFrame.height
        }
    }
    
    @IBAction func sendPressed(_ sender: Any) {
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
        
        sendMessage(parametersPOST: parametersPOST, parametersPATCH: parametersPATCH, myProfileId: myProfileId)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message", for: indexPath) as! MessageChatCell
        cell.messageLabel.text = messages[indexPath.row].Content
        
        let lastRowIndex = tableView.numberOfRows(inSection: tableView.numberOfSections-1)
        if indexPath.row == lastRowIndex - 1 {
            messageId = messages[indexPath.row].MessageID
        }
        
        if (messages[indexPath.row].Username != defaults.string(forKey: "Username"))
        {
            cell.isIncoming = true
        }
        
        return cell
    }
}
