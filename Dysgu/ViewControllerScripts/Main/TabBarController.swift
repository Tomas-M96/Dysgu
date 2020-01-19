//
//  TabBarController.swift
//  Dysgu
//
//  Created by Tomas Moore on 15/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    var user: User?
    var profile: Profile?
    let defaults = UserDefaults.standard
    
    let alertService = AlertService()
    let networkingService = NetworkingService()

    override func viewDidLoad() {
        super.viewDidLoad()
        networkingService.response(endpoint: "/profiles/" + user!.UserId, method: "GET") { (result: Result<Profile, Error>) in
            switch result {
                case .success(let decodedJSON):
                    //print("GET Profile Success")
                    self.profile = decodedJSON
                    self.defaults.set(decodedJSON.UserID, forKey: "UserId")
                    self.defaults.set(decodedJSON.ProfileID, forKey: "ProfileId")
                    self.defaults.set(decodedJSON.Username, forKey: "Username")
                case .failure(let error):
                    let alert = self.alertService.alert(message: error.localizedDescription)
                    self.present(alert, animated: true)
                print(error)
            }
        }
    }
}
