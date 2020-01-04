//
//  User.swift
//  Dysgu
//
//  Created by Tomas Moore on 02/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import Foundation

struct User: Decodable {
    let userId: Int
    let emailAddress: String
    let password: String
}
