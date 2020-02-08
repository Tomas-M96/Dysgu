//
//  User.swift
//  Dysgu
//
//  Created by Tomas Moore on 02/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import Foundation

struct User: Decodable {
    let UserId: String
    let EmailAddress: String
}

struct Response: Decodable {
    let Response: String
}

