//
//  News.swift
//  Dysgu
//
//  Created by Tomas Moore on 21/04/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import Foundation

struct News: Decodable {
    let NewsID: String
    let Content: String
    let DatePosted: String
}
