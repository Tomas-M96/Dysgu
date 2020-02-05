//
//  GroupMembersViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 05/02/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class GroupMembersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var members = [Profile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
