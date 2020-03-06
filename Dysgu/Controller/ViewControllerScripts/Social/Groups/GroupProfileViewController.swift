//
//  GroupProfileViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 05/02/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class GroupProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    let alertService = AlertService()
    let networkingService = NetworkingService()
    let defaults = UserDefaults.standard

    var profile: Profile?
    var member: GroupProfile?
    var friendsList = [Friend]()
    var friend: Friend?
    var unlockedBadges = [UnlockedBadge]()
    var isFriend = Bool()
    var isPending = Bool()
    
    @IBOutlet weak var aboutText: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    func getUnlockedBadges() {
        if let profileId = member?.ProfileID {
            networkingService.response(endpoint: "/badges/" + profileId, method: "GET") { (result: Result<[UnlockedBadge], Error>) in
                switch result {
                case .success(let decodedJSON):
                    self.unlockedBadges = decodedJSON
                    self.collectionView.reloadData()
                case .failure(let error):
                    let alert = self.alertService.alert(message: error.localizedDescription)
                    self.present(alert, animated: true)
                    print(error)
                }
            }
        }
    }
    
    func getFriendslist() {
        if let profileId = defaults.string(forKey: "ProfileId") {
            networkingService.response(endpoint: "/friends/" + profileId, method: "GET") { (result: Result<[Friend], Error>) in
                switch result {
                    case .success(let decodedJSON):
                        self.friendsList = decodedJSON
                        self.checkFriend()
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    func removeFriend() {
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
    
    func sendRequest(parameters: [String : Any]) {
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
    
    func getProfile() {
        if let username = member?.Username {
            networkingService.response(endpoint: "/profiles/friend/" + username, method: "GET") { (result: Result<Profile, Error>) in
                switch result {
                case .success(let decodedJSON):
                    self.profile = decodedJSON
                    self.setupView()
                case .failure(let error):
                    let alert = self.alertService.alert(message: error.localizedDescription)
                    self.present(alert, animated: true)
                    print(error)
                }
            }
        }
    }
    
    func checkFriend() {
        if friendsList.count != 0 {
            for i in 0...friendsList.count {
                if (member?.ProfileID == friendsList[i].ProfileOne) || (member?.ProfileID == friendsList[i].ProfileTwo) {
                    isFriend = true
                    friend = friendsList[i]
                    actionSetup()
                    break
                }else{
                    isFriend = false
                    actionSetup()
                }
            }
        }else{
            isFriend = false
            actionSetup()
        }
    }
    
    func setupView() {
        aboutText.text = profile?.About
        profileImage.image = UIImage(named: profile?.Image ?? "default.png")
    }
    
    func actionSetup() {
        if (isFriend) {
            actionButton.isEnabled = true
            actionButton.backgroundColor = .systemRed
            actionButton.titleLabel?.text = "Remove Friend"
        }else{
            actionButton.isEnabled = true
            actionButton.backgroundColor = .systemOrange
            actionButton.titleLabel?.text = "Send Friend Request"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFriendslist()
        getProfile()
        getUnlockedBadges()
    }
    
    @IBAction func actionPressed(_ sender: Any) {
        if (isFriend) {
            removeFriend()
        }else{
            var parameters = [String: Any]()
            
            if let friendId = member?.ProfileID {
                parameters = ["friendId": friendId]
            }
            sendRequest(parameters: parameters)
            actionButton.isEnabled = false
            actionButton.backgroundColor = .systemGray
            actionButton.titleLabel?.text = "Request Pending"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return unlockedBadges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "badge", for: indexPath) as? ImageCollectionViewCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        cell.imageView.image = UIImage(named: "locked.png")//unlockedBadges[indexPath.row].Image)
        return cell
    }
}
