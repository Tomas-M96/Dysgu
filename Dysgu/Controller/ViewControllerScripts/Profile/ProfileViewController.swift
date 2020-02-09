//
//  ProfileViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 14/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITextViewDelegate {
    
    let alertService = AlertService()
    let networkingService = NetworkingService()
    let defaults = UserDefaults.standard
    var profile: Profile?
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var aboutTextView: UITextView!
    
    //Function to configure the navigation bar
    func configureNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(returnSegue))
    }
    
    //Call to the networking service to get the users profile
    func getProfile() {
        if let userId = defaults.string(forKey: "UserId") {
            networkingService.response(endpoint: "/profiles/" + userId, method: "GET") { (result: Result<Profile, Error>) in
                switch result {
                case .success(let decodedJSON):
                    self.profile = decodedJSON
                    self.defaults.set(decodedJSON.About, forKey: "About")
                    self.profileSetup()
                case .failure(let error):
                    let alert = self.alertService.alert(message: error.localizedDescription)
                    self.present(alert, animated: true)
                    print(error)
                }
            }
        }
    }
    
    //Call to the networking service to update the users username
    func patchUsername(parameters: [String : String]) {
        if let profileId = defaults.string(forKey: "ProfileId") {
            if(usernameTextField.text != ""){
                networkingService.request(endpoint: "/profiles/" + profileId, method: "PATCH", parameters: parameters) { (result: Result<Response, Error>) in
                    switch result {
                    case .success:
                        let alert = self.alertService.alert(message: "Username updated to: " + (self.usernameTextField.text ?? "N/A"))
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
    
    //Call to the networking service to update the users bio
    func patchAbout(parameters: [String : String]) {
         if let profileId = defaults.string(forKey: "ProfileId") {
            if(aboutTextView.text != ""){
                    networkingService.request(endpoint: "/profiles/" + profileId, method: "PATCH", parameters: parameters) { (result: Result<Response, Error>) in
                            switch result {
                                case .success:
                                    let alert = self.alertService.alert(message: "About Me Updated")
                                    self.present(alert, animated: true)
                                case .failure(let error):
                                    let alert = self.alertService.alert(message: error.localizedDescription)
                                    self.present(alert, animated: true)
                                print(error)
                            }
                        }
                }else{
                    let alert = self.alertService.alert(message: "This cannot be blank")
                    self.present(alert, animated: true)
                }
            }else{
                let alert = self.alertService.alert(message: "Error: Please log out and try again")
                self.present(alert, animated: true)
        }
    }
    
    //function to set up the view with the profile information
    func profileSetup() {
        profileImage.image = UIImage(named: profile?.Image ?? "person.fill")
        print(profile?.Image)
        aboutTextView.text = profile?.About
        usernameTextField.text = profile?.Username
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Delegates the text view to the view controller
        aboutTextView.delegate = self
        configureNavBar()
        getProfile()
    }
    
    //Refreshes the profile data when returning from the children views
    override func viewWillAppear(_ animated: Bool){
        getProfile()
    }
    
    //Updates the username when editting has stopped in the text field
    @IBAction func usernameChanged(_ sender: Any) {
        let parameters = ["Username": usernameTextField.text]
        patchUsername(parameters: parameters as! [String : String])
    }
    
    //Delegated function for text view action
    func textViewDidEndEditing(_ textView: UITextView) {
        let parameters = ["About": aboutTextView.text]
        patchAbout(parameters: parameters as! [String : String])
    }
    
    //dismisses the view
    @objc func returnSegue(){
        dismiss(animated: true, completion: nil)
    }
}

