//
//  FriendProfileViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 23/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class FriendProfileViewController: UIViewController {

    let networkingService = NetworkingService()
    let alertService = AlertService()
    
    var friend: Friend?
    var profile: Profile?
    
    @IBOutlet weak var aboutField: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let username = friend?.Username {
            networkingService.response(endpoint: "/profiles/friend/" + username, method: "GET") { (result: Result<Profile, Error>) in
                switch result {
                    case .success(let decodedJSON):
                        self.profile = decodedJSON
                        print(self.profile)
                    case .failure(let error):
                        print(error)
                }
            }
        }
        aboutField.text = profile?.About
    }
    
    @IBAction func removePressed(_ sender: Any) {
        if let friendshipId = friend?.FriendshipID {
            networkingService.response(endpoint: "/friends/" + friendshipId, method: "DELETE") { (result: Result<Response, Error>) in
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
