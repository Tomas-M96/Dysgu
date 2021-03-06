//
//  LearnViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 14/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class LearnViewController: UIViewController {

    let alertService = AlertService()
    let networkingService = NetworkingService()
    let defaults = UserDefaults.standard
    var units = [Unit]()
    var lessonUnitId = 0
    
    let stackView = UIStackView()

    @IBOutlet weak var scrollView: UIScrollView!

    func unitButtons() {
        for i in 0...9{
            let button = LessonButton()
            button.setTitle(units[i].Title, for: .normal)
            let unitId = units[i].UnitID; let unitTag = Int(unitId)
            button.tag = unitTag!
            button.heightAnchor.constraint(equalToConstant: 300).isActive = true
            if unitId == "1" {
                button.addTarget(self, action: #selector(buttonClicked(sender: )), for: .touchUpInside)
            }
            stackView.addArrangedSubview(button)
        }
    }

    @objc func buttonClicked(sender: UIButton) {
        lessonUnitId = sender.tag
        performSegue(withIdentifier: "unitSegue", sender: self)
    }
    
    
    func configureStackView() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.spacing = 50
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-30),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        //getUnitList()
        configureNavigationBar()
        //configureStackView()
    }
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(profileSegue))
        navigationItem.leftBarButtonItem?.image = UIImage(systemName: "person.fill")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsSegue))
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: "gear")
    }
    
    @objc func profileSegue(){
        self.performSegue(withIdentifier: "profileSegue", sender: self)
    }
        
    @objc func settingsSegue(){
        self.performSegue(withIdentifier: "settingsSegue", sender: self)
    }
    
    func getUnitList(){
        networkingService.response(endpoint: "/units", method: "GET") { (result: Result<[Unit], Error>) in
            switch result {
                case .success(let decodedJSON):
                    self.units = decodedJSON
                    self.unitButtons()
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unitSegue" {
            if let vc = segue.destination as? LessonSelectViewController {
                vc.unit = units[lessonUnitId-1]
            }
        }
    }
}
