//
//  ChangeAboutViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 19/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class ChangeAboutViewController: UIViewController {
    
    @IBOutlet weak var aboutTextBox: UITextView!
    let alertService = AlertService()
    let networkingService = NetworkingService()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aboutTextBox.text = defaults.string(forKey: "About")
    }
    
    @IBAction func savePressed(_ sender: Any) {
        guard let aboutMe = aboutTextBox.text
            else { return }
        let parameters = ["About": aboutMe]
            
        if let profileId = defaults.string(forKey: "ProfileId") {
            if(aboutMe != ""){
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
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
