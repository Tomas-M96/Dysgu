//
//  SearchFriendViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 23/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class SearchFriendViewController: UIViewController {

    let networkingService = NetworkingService()
    let alertService = AlertService()
    
    var friend: Profile?
    
    @IBOutlet weak var usernameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func searchPressed(_ sender: Any) {
        if let username = usernameField.text {
            networkingService.response(endpoint: "/profiles/friend/" + username, method: "GET") { (result: Result<Profile, Error>) in
                switch result {
                    case .success(let decodedJSON):
                        self.friend = decodedJSON
                        print(self.friend)
                        self.performSegue(withIdentifier: "SearchSuccessSegue", sender: decodedJSON)
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let tabVC = segue.destination as? FriendAddViewController, let decodedJSON = sender as? Profile {
           tabVC.profile = decodedJSON
       }
    }
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
