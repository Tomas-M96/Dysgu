//
//  NewMessageViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 01/02/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class NewMessageViewController: UIViewController {
    
    let alertService = AlertService()
    let networkingService = NetworkingService()
    let defaults = UserDefaults.standard
    
    var friend: Friend?
    
    @IBOutlet weak var messageText: UITextView!
    @IBOutlet weak var subjectText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        postMessage()
    }
    
    func postMessage() {
        guard let content = messageText.text,
              let header = subjectText.text
              else { return }
        
        var recipientId: String?
        
        if friend?.ProfileIDOne == defaults.string(forKey: "ProfileId") {
            recipientId = friend?.ProfileIDTwo
        }else{
            recipientId = friend?.ProfileIDOne
        }

        let username = defaults.string(forKey: "Username")
        
        let parameters = ["recipientId": recipientId,
                          "username": username,
                          "header": header,
                          "content": content]
        
        if let profileId = defaults.string(forKey: "ProfileId") {
            networkingService.request(endpoint: "/messages/" + profileId, method: "POST", parameters: parameters as! [String : String]) { (result: Result<Response, Error>) in
                switch result {
                    case .success:
                        let alert = self.alertService.alert(message: "Message Sent")
                        self.present(alert, animated: true)
                    case .failure(let error):
                        let alert = self.alertService.alert(message: error.localizedDescription)
                        self.present(alert, animated: true)
                        print(error)
                }
            }
        }
    }
}
