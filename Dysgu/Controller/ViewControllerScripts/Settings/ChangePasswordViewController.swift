//
//  ChangePasswordViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 13/05/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    let alertService = AlertService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func save(_ sender: Any) {
        let alert = self.alertService.alert(message: "Password Updated")
        self.present(alert, animated: true)
    }
}
