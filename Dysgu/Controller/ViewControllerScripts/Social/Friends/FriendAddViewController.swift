//
//  FriendAddViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 24/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class FriendAddViewController: UIViewController {
   
    var profile: Profile?
    let defaults = UserDefaults.standard
    let networkingService = NetworkingService()
    let alertService = AlertService()
    
    @IBOutlet weak var aboutField: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    
    func postFriend(_ parameters: [String : Any]) {
        if let profileId = defaults.string(forKey: "ProfileId") {
            networkingService.request(endpoint: "/friends/request/" + profileId, method: "POST", parameters: parameters) { (result: Result<Response, Error>) in
                switch result {
                case .success(let decodedJSON):
                    print(decodedJSON)
                    let alert = self.alertService.alert(message: "Request Sent")
                    self.present(alert, animated: true)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aboutField.text = profile?.About
        if let unwrappedImage = profile?.Image {
            profileImage.image = UIImage(named: (unwrappedImage))
        }
    }
    
    @IBAction func sendRequestPressed(_ sender: Any) {
        var parameters = [String: Any]()
        
        if let friendId = profile?.ProfileID {
            parameters = ["friendId": friendId]
        }
        postFriend(parameters)
    }
}
