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
    override func viewDidLoad() {
        super.viewDidLoad()
        aboutField.text = profile?.About
        print(profile!.ProfileID)
    }
    
    @IBAction func sendRequestPressed(_ sender: Any) {
        
        var parameters = [String: Any]()
        
        if let friendId = profile?.ProfileID {
            parameters = ["friendId": friendId]
        }
        
        print(parameters)

        if let profileId = defaults.string(forKey: "ProfileId") {
            networkingService.request(endpoint: "/friends/" + profileId, method: "POST", parameters: parameters) { (result: Result<Response, Error>) in
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
