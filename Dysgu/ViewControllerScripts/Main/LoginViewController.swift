//
//  LoginViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 02/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    let alertService = AlertService()
    let networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func login(_ sender: Any) {
        guard let emailAddress = emailAddressField.text,
              let password = passwordTextField.text
              else { return }
        
        let parameters = ["EmailAddress": emailAddress,
                          "Password": password]
        
        networkingService.request(endpoint: "/users/login", method: "POST", parameters: parameters) { (result: Result<User, Error>) in
            switch result {
                case .success(let decodedJSON):
                    self.performSegue(withIdentifier: "LoginSuccessTransition", sender: decodedJSON)
                    print(decodedJSON)
                    self.clearText()
                case .failure(let error):
                    let alert = self.alertService.alert(message: error.localizedDescription)
                    self.present(alert, animated: true)
                    self.clearText()
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let tabVC = segue.destination as? TabBarController, let decodedJSON = sender as? User {
           tabVC.user = decodedJSON
       }
    }

    func clearText() {
        emailAddressField.text = ""
        passwordTextField.text = ""
    }
}
