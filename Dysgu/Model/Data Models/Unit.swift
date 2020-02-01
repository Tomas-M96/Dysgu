//
//  Unit.swift
//  Dysgu
//
//  Created by Tomas Moore on 31/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import Foundation

struct Unit: Decodable {
    let UnitID: String
    let NoOfLessons: String
    let Title: String
    let Image: String
}

struct Lesson: Decodable {
    let LessonID: String
    let UnitID: String
    let Topic: String
    let Image: String
}

struct Content: Decodable {
    let ContentID: String
    let LessonID: String
    let Welsh: String
    let English: String
    let Phonetic: String
    let Audio: String
    let Tips: String
}
