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
        
        networkingService.request(endpoint: "/users/login", method: "POST", parameters: parameters) { [weak self] (result) in
            switch result {
            
                case .success(let user):
                    self?.performSegue(withIdentifier: "LoginSuccessTransition", sender: user)
            
                case .failure(let error):
                    guard let alert = self?.alertService.alert(message: error.localizedDescription) else {return}
                    self?.present(alert, animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let mainMenuVC = segue.destination as? MainMenuViewController, let user = sender as? User {
            
            mainMenuVC.user = user
        }
    }
    
}
