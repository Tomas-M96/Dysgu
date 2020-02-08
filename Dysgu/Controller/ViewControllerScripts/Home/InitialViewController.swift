//
//  InitialViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 08/02/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Checks if the user is still currently logged in and if so, take them straight to the app
        if let profileId = defaults.string(forKey: "ProfileId") {
            print(profileId)
            performSegue(withIdentifier: "loginSuccessSegue", sender: self)
        }
    }
}
