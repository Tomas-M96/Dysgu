//
//  Friends.swift
//  Dysgu
//
//  Created by Tomas Moore on 19/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import Foundation

struct Friend: Decodable {
    let FriendshipID: String
    let Username: String
    let ProfileOne: String
    let ProfileTwo: String?
    //let Accepted: String
}


