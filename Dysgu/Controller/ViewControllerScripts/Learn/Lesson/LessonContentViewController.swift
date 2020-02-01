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
        welshLabel.text = content?.Welsh
        phoneticLabel.text = content?.Phonetic
        tipsText.text = content?.Tips
                
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Quiz", style: .plain, target: self, action: #selector(quizSegue))
    }
    
    @objc func quizSegue() {}
    
    @IBAction func audioPressed(_ sender: Any) {
    }
}
