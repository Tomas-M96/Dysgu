//
//  FriendAcceptViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 24/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class FriendAcceptViewController: UIViewController {

    let networkingService = NetworkingService()
    let alertService = AlertService()
    
    var friend: Friend?
    var response: Response?
    
    @IBOutlet weak var aboutText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.friend)
    }
    
    @IBAction func acceptPressed(_ sender: Any) {
        if let friendshipId = friend?.FriendshipID {
            networkingService.response(endpoint: "/friends/" + friendshipId, method: "PATCH") { (result: Result<Response, Error>) in
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
