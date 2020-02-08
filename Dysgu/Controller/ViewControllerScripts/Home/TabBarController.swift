//
//  TabBarController.swift
//  Dysgu
//
//  Created by Tomas Moore on 15/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    //Structs to hold the user and profile data
    var user: User?
    var profile: Profile?
    let defaults = UserDefaults.standard
    
    let alertService = AlertService()
    let networkingService = NetworkingService()

    //Network call to get the users profile
    func getProfiles() {
        networkingService.response(endpoint: "/profiles/" + user!.UserId, method: "GET") { (result: Result<Profile, Error>) in
            switch result {
            case .success(let decodedJSON):
                self.profile = decodedJSON
                //Saves data to user defaults
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Checks if the user is still logged in, if they aren't then call the networking service
        if let profileId = defaults.string(forKey: "ProfileId") {}else{
            getProfiles()
        }
    }
}
