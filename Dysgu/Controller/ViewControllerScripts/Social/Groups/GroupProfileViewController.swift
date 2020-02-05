//
//  GroupProfileViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 05/02/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class GroupProfileViewController: UIViewController {

    let alertService = AlertService()
    let networkingService = NetworkingService()
    let defaults = UserDefaults.standard

    var member: Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
