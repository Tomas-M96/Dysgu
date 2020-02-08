//
//  UnitChallengeSelectViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 07/02/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class UnitChallengeSelectViewController: UIViewController {

    
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
            button.addTarget(self, action: #selector(buttonClicked(sender: )), for: .touchUpInside)
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
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:50),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-50),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        getUnitList()
        configureStackView()
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
            if let vc = segue.destination as? LessonChallengeSelectViewController {
                vc.unit = units[lessonUnitId-1]
            }
        }
    }
}
