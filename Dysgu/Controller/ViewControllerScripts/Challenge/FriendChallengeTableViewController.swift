//
//  FriendChallengeTableViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 07/02/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class FriendChallengeTableViewController: UITableViewController {

    let alertService = AlertService()
    let networkingService = NetworkingService()
    var friendsList = [Friend]()
    let defaults = UserDefaults.standard
    
    func getFriendslist() {
        if let profileId = defaults.string(forKey: "ProfileId") {
            networkingService.response(endpoint: "/friends/" + profileId, method: "GET") { (result: Result<[Friend], Error>) in
                switch result {
                    case .success(let decodedJSON):
                        self.friendsList = decodedJSON
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            getFriendslist()
    }

    override func viewDidAppear(_ animated: Bool) {
          tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend", for: indexPath)
        let friend = friendsList[indexPath.row]
        cell.textLabel?.text = friend.Username
        return cell
      }
      
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "FriendAccept") as? FriendAcceptViewController{
            //vc.friend = friendRequest[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
}
