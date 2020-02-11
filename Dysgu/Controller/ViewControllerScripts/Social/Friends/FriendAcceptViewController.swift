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
    var profile: Profile?
    
    @IBOutlet weak var aboutText: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    
    func patchFriend() {
        print(friend?.FriendshipID)
        
        if let friendshipId = friend?.FriendshipID {
            networkingService.response(endpoint: "/friends/" + friendshipId, method: "PATCH") { (result: Result<Response, Error>) in
                switch result {
                case .success(let decodedJSON):
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getFriend() {
        if let username = friend?.Username {
            networkingService.response(endpoint: "/profiles/friend/" + username, method: "GET") { (result: Result<Profile, Error>) in
                switch result {
                case .success(let decodedJSON):
                    self.profile = decodedJSON
                    self.profileSetup()
                    print(self.profile)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    func profileSetup() {
        aboutText.text = profile?.About
        if let unwrappedImage = profile?.Image {
            profileImage.image = UIImage(named: unwrappedImage)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFriend()
    }
    
    @IBAction func acceptPressed(_ sender: Any) {
        patchFriend()
    }
}
