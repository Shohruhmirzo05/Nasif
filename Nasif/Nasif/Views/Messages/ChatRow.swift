//
//  ChatRow.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 13/02/25.
//

import SwiftUI

struct Chat: Identifiable, Hashable {
    let id: Int
    var messages: [Message]
    
    var messageCount: Int {
        return messages.count
    }
    
    var lastMessage: String {
        return messages.last?.messageContent ?? ""
    }
    
    var chatName: String {
        if let firstMessage = messages.first {
            if firstMessage.groupID != nil {
                return "Group Chat #\(id)"
            } else {
                return "User ID: \(firstMessage.recipientID ?? -1)"
            }
        }
        return ""
    }
}

struct ChatRow: View {
    let chat: Chat
    let chatImage: String
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(chat.chatName)
                        .font(.headline)
                    
                    Text(chat.lastMessage)
                        .foregroundColor(.gray.opacity(0.7))
                        .lineLimit(1)
                        .font(.subheadline)
                }
                Spacer()
                Text("\(chat.messageCount) messages")
                    .font(.caption)
                    .foregroundColor(.gray)
                Image(systemName: chatImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45)
                    .foregroundColor(.gray.opacity(0.5))
            }
            Divider()
        }
    }
}

struct MessageRow: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.senderID == 1 {
                Spacer()
                Text(message.messageContent ?? "")
                    .padding(12)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(20)
                    .foregroundColor(.blue)
            } else {
                Text(message.messageContent ?? "")
                    .padding(12)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                    .foregroundColor(.black)
                Spacer()
            }
        }
        .padding(.vertical, 4)
    }
}
