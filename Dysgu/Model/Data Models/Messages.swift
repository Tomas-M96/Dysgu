//
//  Messages.swift
//  Dysgu
//
//  Created by Tomas Moore on 26/01/2020.
//  Copyright © 2020 Tomas Moore. All rights reserved.
//

import Foundation

struct Conversation: Decodable {
    let ConversationID: String
    let Username: String
    let Header: String
    let Viewed: String
    let RecipientID: String
    let ProfileID: String
}

struct Messages: Decodable {
    let MessageID: String
    let ParentMessageID: String?
    let Content: String
    let Username: String
}
