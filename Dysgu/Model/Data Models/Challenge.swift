//
//  Challenge.swift
//  Dysgu
//
//  Created by Tomas Moore on 07/02/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import Foundation

struct Challenge: Decodable {
    let ChallengeID: String?
    let LessonID: String?
    let PlayerOne: String?
    let PlayerTwo: String?
    let topic: String
    let Username: String
    let ScoreOne: String?
    let ScoreTwo: String?
    let Winner: String?
    let DateCreated: String?
}

struct LastID: Decodable {
    let Response: Int
}
