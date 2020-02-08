//
//  ChallengeHistoryViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 06/02/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class ChallengeHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let alertService = AlertService()
    let networkingService = NetworkingService()
    var challenges = [Challenge]()
    var defaults = UserDefaults.standard
    
    @IBOutlet weak var challengesTable: UITableView!
    
    func getHistorical() {
        if let profileId = defaults.string(forKey: "ProfileId"){
            networkingService.response(endpoint: "/challenges/" + profileId + "/history", method: "GET") { (result: Result<[Challenge], Error>) in
                switch result {
                case .success(let decodedJSON):
                    self.challenges = decodedJSON
                    self.challengesTable.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Challenge", for: indexPath)
        let challenge = challenges[indexPath.row]
        cell.textLabel?.text = challenge.Username
        return cell
    }
}
