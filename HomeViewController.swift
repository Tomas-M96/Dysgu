//
//  HomeViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 29/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(profileSegue))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsSegue))
        print(defaults.string(forKey: "Username"))
    }
    
    @objc func profileSegue(){
        self.performSegue(withIdentifier: "profileSegue", sender: self)
    }
    
    @objc func settingsSegue(){
        self.performSegue(withIdentifier: "settingsSegue", sender: self)
    }
}
