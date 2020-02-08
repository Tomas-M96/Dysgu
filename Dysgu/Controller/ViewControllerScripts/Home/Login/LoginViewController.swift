//
//  LoginViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 02/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //Set the outlets for the textboxes
    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    //Call the AlertService and NetworkingService classes
    let alertService = AlertService()
    let networkingService = NetworkingService()
    
    //Login Network Request
    func loginRequest(parameters: [String:Any]) {
        networkingService.request(endpoint: "/users/login", method: "POST", parameters: parameters) { (result: Result<User, Error>) in
            switch result {
                //Save the success data to decodedJSON
                case .success(let decodedJSON):
                    //Load the next segue if data is genuine
                    self.performSegue(withIdentifier: "loginSuccessSegue", sender: decodedJSON)
                    self.clearText()
                //Save the failure data to error
                case .failure(let error):
                    //Load an alert to show what went wrong
                    let alert = self.alertService.alert(message: "Invalid Credentials")
                    self.present(alert, animated: true)
                    self.clearText()
                    print(error)
            }
        }
    }
    
    //Function to clear textboxes
    func clearText() {
        emailAddressField.text = ""
        passwordTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Action when the login button is pressed
    @IBAction func login(_ sender: Any) {
        guard let emailAddress = emailAddressField.text,
              let password = passwordTextField.text
              else { return }
        
        let parameters = ["EmailAddress": emailAddress,
                          "Password": password]
        
        loginRequest(parameters: parameters)
    }
    
    //Dismisses the view
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //Prepares the next segue for data transfer
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let tabVC = segue.destination as? TabBarController, let decodedJSON = sender as? User {
           tabVC.user = decodedJSON
       }
    }
}
