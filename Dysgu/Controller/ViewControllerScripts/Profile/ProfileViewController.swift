//
//  ProfileViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 14/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var aboutTextBox: UITextView!
    let alertService = AlertService()
    let networkingService = NetworkingService()
    let defaults = UserDefaults.standard
    var profile: Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(returnSegue))
        
        if let userId = defaults.string(forKey: "UserId") {
            networkingService.response(endpoint: "/profiles/" + userId, method: "GET") { (result: Result<Profile, Error>) in
                switch result {
                    case .success(let decodedJSON):
                        self.defaults.set(decodedJSON.About, forKey: "About")
                        print(self.defaults.string(forKey: "About"))
                        self.aboutTextBox.text = decodedJSON.About
                    case .failure(let error):
                        let alert = self.alertService.alert(message: error.localizedDescription)
                        self.present(alert, animated: true)
                    print(error)
                }
            }
        }
    }

    @objc func returnSegue(){
        dismiss(animated: true, completion: nil)
    }
}
