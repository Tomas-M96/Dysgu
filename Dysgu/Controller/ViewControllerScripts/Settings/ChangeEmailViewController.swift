//
//  ChangeEmailViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 13/05/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class ChangeEmailViewController: UIViewController {

    let alertService = AlertService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(_ sender: Any) {
        let alert = self.alertService.alert(message: "Email Address Updated")
        self.present(alert, animated: true)
    }

}
