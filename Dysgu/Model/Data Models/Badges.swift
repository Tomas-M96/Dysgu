//
//  Badges.swift
//  Dysgu
//
//  Created by Tomas Moore on 12/02/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import Foundation

struct Badge: Decodable {
    let BadgeID: String
    let Name: String
    let Description: String
    let Image: String
}

struct UnlockedBadge: Decodable {
    let ProfileId: String?
    let Name: String
    let Description: String
    let Image: String
    let UnlockDate: String?
    let BadgeID: String?
}
