//
//  FeedMessageViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 16/02/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class FeedMessageViewController: UIViewController {

    let alertService = AlertService()
    let networkingService = NetworkingService()
    
    var defaults = UserDefaults.standard
    var group: Group?
    
    @IBOutlet weak var feedText: UITextView!
    
    func postMessage(parameters: [String:String]) {
        if let groupFeedId = defaults.string(forKey: "FeedId"), let profileId = defaults.string(forKey: "ProfileId") {
            if(feedText.text != ""){
                networkingService.request(endpoint: "/feed/3/" + profileId, method: "POST", parameters: parameters) { (result: Result<Response, Error>) in
                    switch result {
                    case .success:
                        let alert = self.alertService.alert(message: "Message Sent")
                        self.present(alert, animated: true)
                        self.dismiss(animated: true, completion: nil)
                    case .failure(let error):
                        let alert = self.alertService.alert(message: error.localizedDescription)
                        self.present(alert, animated: true)
                        print(error)
                    }
                }
            }else{
                let alert = self.alertService.alert(message: "Message cannot be blank")
                self.present(alert, animated: true)
            }
        }else{
            let alert = self.alertService.alert(message: "Error: Please log out and try again")
            self.present(alert, animated: true)
        }
    }
    
    func getGroupFeed() {
        if let groupId = group?.GroupID {
            networkingService.response(endpoint: "/14/feed", method: "GET") { (result: Result<[FeedMessage], Error>) in
                switch result {
                    case .success(let decodedJSON):
                        //self.messages = decodedJSON
                    print("a")
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        let parameters = ["Content": feedText.text]
        
        let alert = self.alertService.alert(message: "Message Sent")
        self.present(alert, animated: true)
        
        //postMessage(parameters: parameters as! [String : String])
    }
}
