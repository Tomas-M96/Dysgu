//
//  ChallengeMethodViewController.swift
//  Dysgu
//
//  Created by Tomas Moore on 07/02/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import UIKit

class ChallengeMethodViewController: UIViewController {

    let alertService = AlertService()
    let networkingService = NetworkingService()
    let defaults = UserDefaults.standard
    var challengeId = String()
    var lesson: Lesson?
    var profiles = [Profile]()

    
    func getRandomProfileId() {
        networkingService.response(endpoint: "/profiles", method: "GET") { (result: Result<[Profile], Error>) in
            switch result {
                case .success(let decodedJSON):
                    self.profiles = decodedJSON
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func createChallenge(recipient: String) {
        let parameters = ["RecipientID": recipient,
                          "LessonID": lesson!.LessonID] as [String : Any]
        
        if let profileId = defaults.string(forKey: "ProfileId") {
            networkingService.request(endpoint: "/challenges/" + profileId, method: "POST", parameters: parameters) { (result: Result<LastID, Error>) in
                switch result {
                    case .success(let decodedJSON):
                        self.challengeId = String(decodedJSON.Response)
                        self.performSegue(withIdentifier: "quizSegue", sender: self)
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        getRandomProfileId()
    }
    
    @IBAction func strangerPressed(_ sender: Any) {
        profiles.shuffle()
        
        if (profiles[0].ProfileID != defaults.string(forKey: "ProfileId")) {
            //getLessonContent()
            createChallenge(recipient: profiles[0].ProfileID)
        } else {
            //getLessonContent()
            profiles.shuffle()
            createChallenge(recipient: profiles[0].ProfileID)
        }
    }
    
    @IBAction func yourselfPressed(_ sender: Any) {
        createChallenge(recipient: profiles[0].ProfileID)
        performSegue(withIdentifier: "quizSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "quizSegue" {
            if let vc = segue.destination as? ChallengeQuizViewController {
                vc.lessonId = lesson!.LessonID
                vc.challengeId = challengeId
                vc.recipientId = String(profiles[0].ProfileID)
            }
        }
    }
}
