//
//  SettingsViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 14/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(returnSegue))
    }
    
    @objc func returnSegue(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logOut(_ sender: Any) {
        resetDefaults()
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}
