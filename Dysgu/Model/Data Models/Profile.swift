//
//  Profile.swift
//  Dysgu
//
//  Created by Tomas Moore on 15/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import Foundation

struct Profile: Decodable {
    let ProfileID: String
    let UserID: String
    let Username: String
    let About: String?
    let Image: String?
}

struct GroupProfile: Decodable {
    let Username: String
    let ProfileID: String
    let GroupID: String
    let IsAdmin: String
}
