//
//  BadgeDetailViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 14/02/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class BadgeDetailViewController: UIViewController {

    let networkingService = NetworkingService()
    
    var badge: UnlockedBadge?
    var badgeId: String?
    var defaults = UserDefaults.standard
    
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var unlockText: UILabel!
    
    func getUnlockedBadge() {
        if let profileId = defaults.string(forKey: "ProfileId"), let badgeId = defaults.string(forKey: "BadgeId") {
            networkingService.response(endpoint: "/badges/" + profileId + "/" + badgeId, method: "GET") { (result: Result<UnlockedBadge, Error>) in
                switch result {
                    case .success(let decodedJSON):
                        self.badge = decodedJSON
                        self.badgeSetup()
                    case .failure(let error):
                        print("not unlocked")
                        self.getLockedBadge()
                        print(error)
                }
            }
        }
    }
    
    func getLockedBadge() {
        if let badgeId = defaults.string(forKey: "BadgeId") {
            networkingService.response(endpoint: "/badge/" + badgeId, method: "GET") { (result: Result<UnlockedBadge, Error>) in
                switch result {
                    case .success(let decodedJSON):
                        self.badge = decodedJSON
                        self.badgeSetup()
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    func badgeSetup() {
        nameText.text = badge?.Name
        descriptionText.text = badge?.Description
        unlockText.text = badge?.UnlockDate ?? "Not Unlocked"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUnlockedBadge()
    }
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
