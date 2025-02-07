//
//  MessagesView.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 09/01/25.
//

import SwiftUI

struct User: Codable {
    let userID: Int
    let mobileNumber, nickname: String
    let profilePictureURL: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case mobileNumber = "mobile_number"
        case nickname
        case profilePictureURL = "profile_picture_url"
        case createdAt = "created_at"
    }
    
    static let mock: User = User(userID: 0, mobileNumber: "00000000", nickname: "mock", profilePictureURL: "", createdAt: "")
}

@MainActor
class MessageViewModel: ObservableObject {
    @Published var messagesByUserId: [Message] = []
    @Published var user: User?
    @Published var currentState: ViewState = .none
    @Published var searchQuery: String = ""
//    @Published var g
    
    private var webSocketManager = WebSocketManager.shared  // To manage real-time WebSocket communication
    private var userId: Int
    
    init() {
        // Get the userId from UserDefaults or any other source
        if let userId = UserDefaults.standard.value(forKey: "userId") as? Int {
            self.userId = userId
            getMessagesByUserId(userId: userId)
            setUpWebSocket()
        } else {
            self.userId = 0
            currentState = .error("User ID not found")
        }
    }
    
    // Function to get all messages by userId
    func getMessagesByUserId(userId: Int) {
        currentState = .loading
        Task {
            do {
                let response = try await APIClient.shared.callWithStatusCode(.getMessagesByUserId(userId: userId), decodeTo: [Message].self)
                DispatchQueue.main.async {
                    self.messagesByUserId = response.data
                    self.currentState = .none
                }
            } catch {
                print("Error fetching messages by userId:", error.localizedDescription)
                currentState = .error(error.localizedDescription)
            }
        }
    }
    
    // Function to get user by nickname
    func getUserByNickname(nickName: String) {
        currentState = .loading
        Task {
            do {
                let response = try await APIClient.shared.callWithStatusCode(.getUserByNickname(nickName: nickName), decodeTo: User.self)
                DispatchQueue.main.async {
                    self.user = response.data
                    self.currentState = .none
                }
            } catch {
                print("Error fetching user by nickname:", error.localizedDescription)
                currentState = .error(error.localizedDescription)
            }
        }
    }
    
    // Set up WebSocket to listen for incoming messages
    private func setUpWebSocket() {
        webSocketManager.connect()
        
        // When a new message is received over WebSocket
        webSocketManager.onMessageReceived = { [weak self] message in
            self?.handleIncomingMessage(message)
        }
    }
    
    // Function to handle incoming WebSocket messages
    private func handleIncomingMessage(_ message: Message) {
        // Check if the message sender is the user you are viewing
        if message.senderID == user?.userID {
            DispatchQueue.main.async {
                self.messagesByUserId.append(message)
            }
        }
    }
    
    // Function to send a message via WebSocket
    func sendMessage(content: String, recipientId: Int) {
        let message = Message(id: userId, senderID: self.userId, recipientID: recipientId, groupID: , messageContent: content, createdAt: getCurrentTimestamp())
        
        // Send message via WebSocket
        webSocketManager.sendTextMessage(message, toRecipientId: recipientId)
        
        // Optionally, append the sent message to the local messages array
        DispatchQueue.main.async {
            self.messagesByUserId.append(message)
        }
    }
    
    // Helper function to get current timestamp
    private func getCurrentTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }

    var filteredMessages: [Message] {
        guard !searchQuery.isEmpty else { return messagesByUserId }
        return messagesByUserId.filter { $0.messageContent?.lowercased().contains(searchQuery.lowercased()) ?? false }
    }
    
    enum ViewState: Equatable {
        case loading, none, error(_ description: String)
    }
}


//class MessageViewModel: ObservableObject {
//    @Published var messagesByUserId: [Message] = []
//    @Published var user: User?
//    @Published var currentState: ViewState = .none
//    @Published var searchQuery: String = ""
//    
//    init() {
//        if let userId = UserDefaults.standard.value(forKey: "userId") as? Int {
//            getMessagesByUserId(userId: userId)
//        } else {
//            currentState = .error("User ID not found")
//        }
//    }
//    
//    func getMessagesByUserId(userId: Int) {
//        currentState = .loading
//        Task {
//            do {
//                let response = try await APIClient.shared.callWithStatusCode(.getMessagesByUserId(userId: userId), decodeTo: [Message].self)
//                DispatchQueue.main.async {
//                    self.messagesByUserId = response.data
//                    self.currentState = .none
//                }
//            } catch {
//                print("Error fetching messages by userId:", error.localizedDescription)
//                currentState = .error(error.localizedDescription)
//            }
//        }
//    }
//    
//    func getUserByNickname(nickName: String) {
//        currentState = .loading
//        Task {
//            do {
//                let response = try await APIClient.shared.callWithStatusCode(.getUserByNickname(nickName: nickName), decodeTo: User.self)
//                DispatchQueue.main.async {
//                    self.user = response.data
//                    self.currentState = .none
//                }
//            } catch {
//                print("Error fetching user by nickname:", error.localizedDescription)
//                currentState = .error(error.localizedDescription)
//            }
//        }
//    }
//    
//    var filteredMessages: [Message] {
//        guard !searchQuery.isEmpty else { return messagesByUserId }
//        return messagesByUserId.filter { $0.messageContent?.lowercased().contains(searchQuery.lowercased()) ?? false }
//    }
//    
//    enum ViewState: Equatable {
//        case loading, none, error(_ description: String)
//    }
//}


struct MessagesView: View {
    @StateObject var viewModel: MessageViewModel = MessageViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    TextField("Search", text: $viewModel.searchQuery)
                        .padding(10)
                        .background(Color.accent.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.filteredMessages) { message in
                            MessageRowCard(message: message)
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Communication")
                        .font(.abel(size: 20))
                }
            }
        }
    }
}

struct MessageRowCard: View {
    let message: Message
    
    var body: some View {
        VStack {
            HStack(spacing: 12) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45)
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Sender ID: \(message.senderID ?? -1)")
                        .font(.abel(size: 14))
                    
                    Text(message.messageContent ?? "")
                        .foregroundColor(.gray.opacity(0.7))
                        .lineLimit(1)
                        .font(.abel(size: 12))
                }
                
                Spacer()
                
                Text(formatDate(message.createdAt ?? ""))
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(maxHeight: .infinity, alignment: .top)
            }
            Divider()
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateStyle = .short
            outputFormatter.timeStyle = .short
            return outputFormatter.string(from: date)
        }
        return ""
    }
}
