//
//  RegistrationViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 08/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    //Create outlets for the texboxes
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfField: UITextField!
    
    //Call the alert and networking services
    let alertService = AlertService()
    let networkingService = NetworkingService()
    
    //Networking call to register the account
    func registerAccount(_ parameters: [String : String]) {
        networkingService.request(endpoint: "/users", method: "POST", parameters: parameters) { (result: Result<Response, Error>) in
            switch result {
            case .success:
                let alert = self.alertService.alert(message: "Account Created")
                self.present(alert, animated: true)
            case .failure(let error):
                let alert = self.alertService.alert(message: error.localizedDescription)
                self.present(alert, animated: true)
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Button to dismiss the view
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //Action to call the register process
    @IBAction func registerTapped(_ sender: Any) {
        guard let username = usernameField.text,
              let emailAddress = emailField.text,
              let password = passwordField.text,
              let passwordConf = passwordConfField.text
              else { return }
        
        let parameters = ["Username": username,
                          "EmailAddress": emailAddress,
                          "Password": password]
        
        //Checks if the password field matches the confirmation field
        if(password == passwordConf) {
            registerAccount(parameters)
        }else{
            let alert = self.alertService.alert(message: "Passwords do not match")
            self.present(alert, animated: true)
        }
    }
}
