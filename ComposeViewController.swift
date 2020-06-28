//
//  ComposeViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 29/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let alertService = AlertService()
    let networkingService = NetworkingService()
    var friendsList = [Friend]()
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var friendTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getFriendslist()
    }
       
    override func viewDidAppear(_ animated: Bool) {
        friendTable.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend", for: indexPath)
        let friend = friendsList[indexPath.row]
        cell.textLabel?.text = friend.Username
        return cell
    }
       
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*if let vc = storyboard?.instantiateViewController(withIdentifier: "NewMessage") as?
            NewMessageViewController{
                vc.friend = friendsList[indexPath.row]
                navigationController?.pushViewController(vc, animated: true)
        }*/
        performSegue(withIdentifier: "composeSegue", sender: self)
    }
       
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
}
