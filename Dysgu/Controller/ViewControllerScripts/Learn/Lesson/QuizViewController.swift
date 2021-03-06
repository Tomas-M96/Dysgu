//
//  QuizViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 29/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    let alertService = AlertService()
    let networkingService = NetworkingService()
    //let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFire), userInfo: nil, repeats: true)
    var lesson: Lesson?
    var contents = [Content]()
    var questions = [Question]()
    var question = Question(English: "", Welsh: "")
    var currentQuestion = 0
    var rightAnswerPlacement:UInt32 = 0
    var score = 0
    var time = 999
    
    @IBOutlet weak var questionText: UITextView!
    @IBOutlet weak var scoreText: UILabel!
    @IBOutlet weak var timeText: UILabel!
    
    func createQuestions() {
        for i in 0...contents.count-1 {
            question.English = contents[i].English
            question.Welsh = contents[i].Welsh
            questions.append(self.question)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            //timer.invalidate()
            let alert = self.alertService.alert(message: "Your score was \(score)")
            self.present(alert, animated: true)
        }else{
            let alert = self.alertService.alert(message: "Incorrect")
            self.present(alert, animated: true)
            nextQuestion()
        }
    }
    
    @objc func timerFire() {
        //time -= 1
        //timeText.text = "Time: " + String(time)
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
    
    override func viewDidAppear(_ animated: Bool) {
        print(self.questions)
    }
}
