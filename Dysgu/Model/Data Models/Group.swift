//
//  Group.swift
//  Dysgu
//
//  Created by Tomas Moore on 03/02/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import Foundation

struct FeedMessage: Decodable {
    //let FeedMessageID: String
    let GroupFeedID: String
    //let ProfileID: String?
    let Content: String
    let DatePosted: String
    let Username: String
}

struct Group: Decodable {
    let GroupID: String
    let Name: String
    let About: String
    let Image: String
}

struct GroupID: Decodable {
    let Response: Int
}
