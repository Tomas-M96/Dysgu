//
//  GroupMembersViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 05/02/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class GroupMembersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let alertService = AlertService()
    let networkingService = NetworkingService()
    
    var group: Group?
    var members = [GroupProfile]()
    
    @IBOutlet weak var membersTable: UITableView!
    
    func getMembers() {
        if let groupId = group?.GroupID {
            networkingService.response(endpoint: "/groups/" + groupId + "/members", method: "GET") { (result: Result<[GroupProfile], Error>) in
                switch result {
                    case .success(let decodedJSON):
                        self.members = decodedJSON
                        print(decodedJSON)
                        self.membersTable.reloadData()
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMembers()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Member", for: indexPath)
        let member = members[indexPath.row]
        cell.textLabel?.text = member.Username
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "GroupProfile") as? GroupProfileViewController{
            vc.member = members[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
