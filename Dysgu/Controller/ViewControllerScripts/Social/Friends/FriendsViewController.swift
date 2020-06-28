//
//  FriendsViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 21/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let alertService = AlertService()
    let networkingService = NetworkingService()
    var friendsList = [Friend]()
    var friendRequest = [Friend]()
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var friendTable: UITableView!
    
    func getFriendslist() {
        if let profileId = defaults.string(forKey: "ProfileId") {
            networkingService.response(endpoint: "/friends/list/" + profileId, method: "GET") { (result: Result<[Friend], Error>) in
                switch result {
                    case .success(let decodedJSON):
                        self.friendsList = decodedJSON
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    func getFriendRequests() {
        if let profileId = defaults.string(forKey: "ProfileId") {
            networkingService.response(endpoint: "/friends/request/" + profileId , method: "GET") { (result: Result<[Friend], Error>) in
                switch result {
                    case .success(let decodedJSON):
                        self.friendRequest = decodedJSON
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
           getFriendslist()
           getFriendRequests()
           navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchfriend))
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "plus.circle.fill")
    }
    
    @objc func searchfriend() {
       performSegue(withIdentifier: "searchFriend", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFriendslist()
        getFriendRequests()
        segmentChange(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        friendTable.reloadData()
    }
    
    @IBAction func segmentChange(_ sender: Any) {
        if (segmentControl.selectedSegmentIndex == 1){
            getFriendRequests()
            friendTable.reloadData()
        } else {
            getFriendslist()
            friendTable.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (segmentControl.selectedSegmentIndex == 1) {
            return friendRequest.count
        } else {
            return friendsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (segmentControl.selectedSegmentIndex == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Friend", for: indexPath)
            let friend = friendRequest[indexPath.row]
            cell.textLabel?.text = friend.Username
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Friend", for: indexPath)
            let friend = friendsList[indexPath.row]
            cell.textLabel?.text = friend.Username
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (segmentControl.selectedSegmentIndex == 1) {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "FriendAccept") as?
                FriendAcceptViewController{
                    vc.friend = friendRequest[indexPath.row]
                    navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "FriendProfile") as?
                FriendProfileViewController{
                    vc.friend = friendsList[indexPath.row]
                    navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
