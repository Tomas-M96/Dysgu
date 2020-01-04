//
//  ErrorResponse.swift
//  Dysgu
//
//  Created by Tomas Moore on 02/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import Foundation

struct ErrorResponse: Decodable, LocalizedError {
    let reason: String
}
