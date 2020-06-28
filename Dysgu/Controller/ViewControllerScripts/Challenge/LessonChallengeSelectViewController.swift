//
//  LessonChallengeSelectViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 07/02/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class LessonChallengeSelectViewController: UIViewController {

    let alertService = AlertService()
    let networkingService = NetworkingService()
    let stackView = UIStackView()
    var unit: Unit?
    var lessons = [Lesson]()
    var lessonId = 0

    @IBOutlet weak var scrollView: UIScrollView!
     
    func lessonButtons() {
        for i in 0...lessons.count-1 {
            let button = LessonButton()
            button.setTitle(lessons[i].Topic, for: .normal)
            button.heightAnchor.constraint(equalToConstant: 300).isActive = true
            let lessonId = lessons[i].LessonID; let lessonTag = Int(lessonId)
            button.tag = lessonTag!
            button.addTarget(self, action: #selector(buttonClicked(sender: )), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
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
    
    @objc func buttonClicked(sender: UIButton) {
        lessonId = sender.tag
        performSegue(withIdentifier: "lessonSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLessonList()
        //configureStackView()
    }
    
    func getLessonList(){
        if let unitId = unit?.UnitID{
            networkingService.response(endpoint: "/unit/" + unitId + "/lessons" , method: "GET") { (result: Result<[Lesson], Error>) in
                switch result {
                    case .success(let decodedJSON):
                        self.lessons = decodedJSON
                        self.lessonButtons()
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lessonSegue" {
            if let vc = segue.destination as? ChallengeMethodViewController {
                vc.lesson = lessons[lessonId-1]
            }
        }
    }*/
}
