//
//  Message.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 30/01/25.
//

import SwiftUI

struct Message: Codable, Identifiable, Hashable {
    let id: Int?
    let senderID, recipientID: Int?
    let groupID: Int?
    let messageContent, createdAt: String?
    let mediaType: String?

    enum CodingKeys: String, CodingKey {
        case id = "message_id"
        case senderID = "sender_id"
        case recipientID = "recipient_id"
        case groupID = "group_id"
        case messageContent = "message_content"
        case createdAt = "created_at"
        case mediaType = "media_type"
    }
    
    static let mock = Message(
        id: -1,
        senderID: -1,
        recipientID: 2,
        groupID: 1,
        messageContent: "Hello World MOCK",
        createdAt: "2025-01-30T12:00:00Z",
        mediaType: ""
    )
}

struct MediaMessage {
    let data: Data
    let filename: String
    let mimeType: String
}

extension Message {
    enum MediaType: String {
        case text = "text"
        case image = "image"
        case video = "video"
        case audio = "audio"
        case file = "file"
    }
}
