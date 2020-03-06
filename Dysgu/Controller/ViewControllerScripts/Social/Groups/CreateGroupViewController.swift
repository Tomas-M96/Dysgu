//
//  CreateGroupViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 18/02/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController {

    let alertService = AlertService()
    let networkingService = NetworkingService()
    let defaults = UserDefaults.standard
    
    var groupId: GroupID?
    
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var aboutText: UITextView!
    
    func postGroup(parameters: [String:String]) {
        networkingService.request(endpoint: "/groups", method: "POST", parameters: parameters) { (result: Result<GroupID, Error>) in
            switch result {
                //Save the success data to decodedJSON
                case .success(let decodedJSON):
                    self.groupId = decodedJSON
                    self.postUser(parameters: ["IsAdmin": "1"])
                //Save the failure data to error
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func postUser(parameters: [String:String]) {
        let stringGroupId = groupId!.Response
        if let profileId = defaults.string(forKey: "ProfileId") {
            networkingService.request(endpoint: "/groups/" + String(stringGroupId) + "/" + profileId, method: "POST", parameters: parameters) { (result: Result<Response, Error>) in
                switch result {
                    //Save the success data to decodedJSON
                    case .success(_):
                        print("Success")
                        self.navigationController?.popViewController(animated: true)
                    //Save the failure data to error
                    case .failure(let error):
                        print(error)
                }
            }

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupImage.image = UIImage(named: "abc.png")
        defaults.removeObject(forKey: "GroupPic")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        groupImage.image = UIImage(named: defaults.string(forKey: "GroupPic") ?? "default")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "picSegue" {
            if let vc = segue.destination as? GroupPictureCollectionViewController {
                vc.isNew = true
            }
        }
    }
    
    @IBAction func createPressed(_ sender: Any) {
        if (groupImage.image != UIImage(systemName: "default")) {
            let parameters = ["Name": nameText.text,
                              "About": aboutText.text,
                              "Image": defaults.string(forKey: "GroupPic")]
            
            postGroup(parameters: parameters as! [String : String])
        } else {
            
        }
        
    }
    
}
