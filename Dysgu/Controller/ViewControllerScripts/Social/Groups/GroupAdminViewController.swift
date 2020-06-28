//
//  GroupAdminViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 15/02/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class GroupAdminViewController: UIViewController {

    let alertService = AlertService()
    let networkingService = NetworkingService()
    let defaults = UserDefaults.standard
    
    var group: Group?
    
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var aboutText: UITextView!
    
    
    func getGroup() {
        if let groupId = group?.GroupID {
            networkingService.response(endpoint: "/groups/" + groupId, method: "GET") { (result: Result<Group, Error>) in
                switch result {
                    case .success(let decodedJSON):
                        self.group = decodedJSON
                        self.viewSetup()
                        print(decodedJSON)
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    func patchGroup(parameters: [String:String]) {
        if let groupId = group?.GroupID {
            if(aboutText.text != ""){
                networkingService.request(endpoint: "/groups/" + groupId, method: "PATCH", parameters: parameters) { (result: Result<Response, Error>) in
                    switch result {
                    case .success:
                        let alert = self.alertService.alert(message: "About Updated")
                        self.present(alert, animated: true)
                        self.getGroup()
                    case .failure(let error):
                        let alert = self.alertService.alert(message: error.localizedDescription)
                        self.present(alert, animated: true)
                        print(error)
                    }
                }
            }else{
                let alert = self.alertService.alert(message: "About cannot be blank")
                self.present(alert, animated: true)
            }
        }else{
            let alert = self.alertService.alert(message: "Error: Please log out and try again")
            self.present(alert, animated: true)
        }
    }
    
    func viewSetup() {
        //aboutText.text = self.group?.About
        //groupImage.image = UIImage(named: group?.Image ?? "dragon2.png")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getGroup()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pictureSegue" {
            if let vc = segue.destination as? GroupPictureCollectionViewController {
                vc.group = group
            }
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        let parameters = ["About": aboutText.text]
        let alert = self.alertService.alert(message: "Group Updated")
        self.present(alert, animated: true)
        //patchGroup(parameters: parameters as! [String : String])
    }
}
