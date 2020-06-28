//
//  LessonContentViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 29/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class LessonContentViewController: UIViewController {

    let alertService = AlertService()
    var content: Content?
    
    @IBOutlet weak var welshLabel: UILabel!
    @IBOutlet weak var phoneticLabel: UILabel!
    @IBOutlet weak var tipsText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //welshLabel.text = content?.Welsh
        //phoneticLabel.text = content?.Phonetic
        //tipsText.text = content?.Tips
    }
    
    @IBAction func audioPressed(_ sender: Any) {
        let alert = self.alertService.alert(message: "Playing audio")
        self.present(alert, animated: true)
    }
    
    @IBAction func tipsPressed(_ sender: Any) {
        let alert = self.alertService.alert(message: "No tips available for this item")
        self.present(alert, animated: true)
    }
}
