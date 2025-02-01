//
//  Message.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 30/01/25.
//

import SwiftUI

struct Message: Codable, Identifiable {
    let id: Int?
    let senderID, recipientID: Int?
    let groupID: String?
    let messageContent, createdAt: String

    enum CodingKeys: String, CodingKey {
        case id = "message_id"
        case senderID = "sender_id"
        case recipientID = "recipient_id"
        case groupID = "group_id"
        case messageContent = "message_content"
        case createdAt = "created_at"
    }
    
    static let mock = Message(
        id: -1,
        senderID: -1,
        recipientID: 2,
        groupID: "''",
        messageContent: "Hello World MOCK",
        createdAt: "2025-01-30T12:00:00Z"
    )
}
