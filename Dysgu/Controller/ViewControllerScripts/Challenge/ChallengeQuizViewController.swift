//
//  ChallengeQuizViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 07/02/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class ChallengeQuizViewController: UIViewController {

    let alertService = AlertService()
    let networkingService = NetworkingService()
    let defaults = UserDefaults.standard
    var recipientId = String()
    var challengeId = String()
    var lessonId = String()
    var contents = [Content]()
    var questions = [Question]()
    var question = Question(English: "", Welsh: "")
    var currentQuestion = 0
    var rightAnswerPlacement:UInt32 = 0
    var score = 0
    
   @IBOutlet weak var questionText: UITextView!
   @IBOutlet weak var scoreText: UILabel!
    
    func createQuestions() {
        for i in 0...contents.count-1 {
            question.English = contents[i].English
            question.Welsh = contents[i].Welsh
            questions.append(self.question)
        }
    }
    
    func nextQuestion() {
        
        questionText.text = questions[currentQuestion].Welsh
        rightAnswerPlacement = arc4random_uniform(3)+1
        
        var button:UIButton = UIButton()
        
        for i in 1...4
        {
            button = view.viewWithTag(i) as! UIButton
            let randomAnswer = Int.random(in: 0...questions.count-1)
            
            if(i == Int(rightAnswerPlacement))
            {
                button.setTitle(questions[currentQuestion].English, for: .normal)
            }
            else
            {
                if (button.titleLabel?.text != questions[randomAnswer].English) {
                    button.setTitle(questions[randomAnswer].English, for: .normal)
                }
            }
        }
        currentQuestion += 1
    }
    
    func endChallenge() {
        let parameters = ["RecipientID": recipientId,
                          "Score": score] as [String : Any]
        
        if let profileId = defaults.string(forKey: "ProfileId") {
            networkingService.request(endpoint: "/challenges/" + challengeId + "/" + profileId, method: "PATCH", parameters: parameters) { (result: Result<Response, Error>) in
                switch result {
                    case .success(let decodedJSON):
                        print(decodedJSON)
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    func getLessonContent(){
        networkingService.response(endpoint: "/lessons/" + lessonId + "/content", method: "GET") { (result: Result<[Content], Error>) in
            switch result {
                case .success(let decodedJSON):
                    self.contents = decodedJSON
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLessonContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        createQuestions()
        questions.shuffle()
        nextQuestion()
    }
    
    @IBAction func answerPressed(_ sender: AnyObject) {
        
        if (sender.tag == Int(rightAnswerPlacement) && currentQuestion < 6) {
            let alert = self.alertService.alert(message: "Correct")
            self.present(alert, animated: true)
            nextQuestion()
            score += 1
            scoreText.text = "Score: \(score)"
        }else if (currentQuestion > 5) {
            let alert = self.alertService.alert(message: "Your score was \(score)")
            self.present(alert, animated: true)
            endChallenge()
        }else{
            let alert = self.alertService.alert(message: "Incorrect")
            self.present(alert, animated: true)
            nextQuestion()
        }
    }
}
