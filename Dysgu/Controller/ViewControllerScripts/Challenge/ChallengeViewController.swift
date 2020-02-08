//
//  ChallengeViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 14/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class ChallengeViewController: UIViewController {
    
    let alertService = AlertService()
    let networkingService = NetworkingService()
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var usernameText: UILabel!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        configureNavigationBar()
        usernameText.text = defaults.string(forKey: "Username")
    }
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(profileSegue))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsSegue))
    }
    
    @objc func profileSegue(){
        self.performSegue(withIdentifier: "profileSegue", sender: self)
    }
        
    @objc func settingsSegue(){
        self.performSegue(withIdentifier: "settingsSegue", sender: self)
    }
}
