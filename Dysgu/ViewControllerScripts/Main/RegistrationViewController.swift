//
//  RegistrationViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 08/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfField: UITextField!
    
    let alertService = AlertService()
    let networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        guard let username = usernameField.text,
              let emailAddress = emailField.text,
              let password = passwordField.text,
              let passwordConf = passwordConfField.text
              else { return }
        
        let parameters = ["Username": username,
                          "EmailAddress": emailAddress,
                          "Password": password]
        
        if(password == passwordConf) {
            networkingService.request(endpoint: "/users", method: "POST", parameters: parameters) { [weak self] (result) in
                
                switch result {
                    
                case .success:
                    guard let alert = self?.alertService.alert(message: "Account Created") else {return}
                    self?.present(alert, animated: true)
                    
                case .failure(let error):
                    guard let alert = self?.alertService.alert(message: error.localizedDescription) else {return}
                    self?.present(alert, animated: true)
                }
            }
        } else {
            let alert = self.alertService.alert(message: "Passwords do not match")
            self.present(alert, animated: true)
        }
    }
}
