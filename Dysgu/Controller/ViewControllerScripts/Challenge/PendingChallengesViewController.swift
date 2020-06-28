//
//  PendingChallengesViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 06/02/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class PendingChallengesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let alertService = AlertService()
    let networkingService = NetworkingService()
    var receivedChallenges = [Challenge]()
    var sentChallenges = [Challenge]()
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var challengesTable: UITableView!
    
    func getPending() {
        if let profileId = defaults.string(forKey: "ProfileId"){
            networkingService.response(endpoint: "/challenges/" + profileId + "/received", method: "GET") { (result: Result<[Challenge], Error>) in
                switch result {
                case .success(let decodedJSON):
                    self.receivedChallenges = decodedJSON
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getSent() {
        if let profileId = defaults.string(forKey: "ProfileId"){
            networkingService.response(endpoint: "/challenges/" + profileId + "/sent", method: "GET") { (result: Result<[Challenge], Error>) in
                switch result {
                case .success(let decodedJSON):
                    self.sentChallenges = decodedJSON
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(quizSegue))
    }
    
    @objc func quizSegue() {
        self.performSegue(withIdentifier: "challengeSegue", sender: self)
    }
    
    @IBAction func segmentChange(_ sender: Any) {
        self.challengesTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPending()
        getSent()
        configureNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.challengesTable.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (segmentControl.selectedSegmentIndex == 1) {
            return receivedChallenges.count
        }else{
            return sentChallenges.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Challenge", for: indexPath)
        
        if (segmentControl.selectedSegmentIndex == 1) {
            let challenge = receivedChallenges[indexPath.row]
            //cell.textLabel?.text = challenge.Username
            
        } else {
            let challenge = sentChallenges[indexPath.row]
            //cell.textLabel?.text = challenge.Username
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (segmentControl.selectedSegmentIndex == 1) {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "ChallengeQuiz") as?
                ChallengeQuizViewController{
                vc.lessonId = receivedChallenges[indexPath.row].LessonID!
                vc.challengeId = receivedChallenges[indexPath.row].ChallengeID!
                vc.recipientId = receivedChallenges[indexPath.row].PlayerOne!
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
