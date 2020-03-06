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
    @IBOutlet weak var profileImage: UIImageView!
    
    func getFriend() {
        if let username = friend?.Username {
            networkingService.response(endpoint: "/profiles/friend/" + username, method: "GET") { (result: Result<Profile, Error>) in
                switch result {
                case .success(let decodedJSON):
                    self.profile = decodedJSON
                    self.profileSetup()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func deleteFriend() {
        if let friendshipId = friend?.FriendshipID {
            networkingService.response(endpoint: "/friends/" + friendshipId, method: "DELETE") { (result: Result<Response, Error>) in
                switch result {
                case .success(_):
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func profileSetup() {
        aboutField.text = profile?.About
        if let unwrappedImage = profile?.Image {
            profileImage.image = UIImage(named: unwrappedImage)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFriend()
    }
    
    @IBAction func removePressed(_ sender: Any) {
        deleteFriend()
    }
}
