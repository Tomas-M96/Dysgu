//
//  ChangeUsernameViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 17/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class ChangeUsernameViewController: UIViewController {

    let alertService = AlertService()
    let networkingService = NetworkingService()
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var usernameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        guard let username = usernameField.text
        else { return }
        
        let parameters = ["Username": username]
        
        if let profileId = defaults.string(forKey: "ProfileId") {
            if(username != ""){
                networkingService.request(endpoint: "/profiles/" + profileId, method: "PATCH", parameters: parameters) { (result: Result<Response, Error>) in
                        switch result {
                            case .success:
                                let alert = self.alertService.alert(message: "Username updated to: " + (self.usernameField.text ?? "N/A"))
                                self.present(alert, animated: true)
                            case .failure(let error):
                                let alert = self.alertService.alert(message: error.localizedDescription)
                                self.present(alert, animated: true)
                            print(error)
                        }
                    }
            }else{
                let alert = self.alertService.alert(message: "Please enter a new username")
                self.present(alert, animated: true)
            }
        }else{
            let alert = self.alertService.alert(message: "Error: Please log out and try again")
            self.present(alert, animated: true)
        }
    }
}
