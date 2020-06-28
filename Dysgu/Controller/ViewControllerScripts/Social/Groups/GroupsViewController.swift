//
//  GroupsViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 02/02/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class GroupsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let alertService = AlertService()
    let networkingService = NetworkingService()
    let defaults = UserDefaults.standard

    var allGroups = [Group]()
    var joinedGroups = [Group]()
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var groupTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(newSegue))
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "plus.circle.fill")
        getAllGroups()
        getJoinedGroups()
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        groupTable.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllGroups()
        getJoinedGroups()
    }
    
    @objc func newSegue() {
        performSegue(withIdentifier: "newSegue", sender: self)
    }

    func getAllGroups() {
        networkingService.response(endpoint: "/groups", method: "GET") { (result: Result<[Group], Error>) in
            switch result {
                case .success(let decodedJSON):
                    self.allGroups = decodedJSON
                print(decodedJSON)
                case .failure(let error):
                    print(error)
            }
        }
    }
   
    func getJoinedGroups() {
            if let profileId = defaults.string(forKey: "ProfileId") {
                networkingService.response(endpoint: "/groups/" + profileId + "/profile", method: "GET") { (result: Result<[Group], Error>) in
                switch result {
                    case .success(let decodedJSON):
                        self.joinedGroups = decodedJSON
                        self.groupTable.reloadData()
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (segmentControl.selectedSegmentIndex == 1){
            return allGroups.count
        }else{
            return joinedGroups.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Group", for: indexPath)
        
        if (segmentControl.selectedSegmentIndex == 1){
            let group = allGroups[indexPath.row]
            cell.textLabel?.text = group.Name
        }else{
            let group = joinedGroups[indexPath.row]
            cell.textLabel?.text = group.Name
        }
        
        return cell
    }
    
    @IBAction func stuff(_ sender: Any) {
        performSegue(withIdentifier: "test", sender: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (segmentControl.selectedSegmentIndex == 1) {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "Group") as? GroupViewController{
                    vc.group = allGroups[indexPath.row]
                    vc.hasJoined = false
                    navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            if let vc = storyboard?.instantiateViewController(withIdentifier: "Group") as? GroupViewController{
                    vc.group = joinedGroups[indexPath.row]
                    vc.hasJoined = true
                    navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
