//
//  MessagesView.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 09/01/25.
//

import SwiftUI

struct User: Codable, Hashable {
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

struct Chat: Identifiable, Hashable {
    let id: Int
    let messages: [Message]
    
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
        return "Unknown Chat"
    }
}

@MainActor
class MessageViewModel: ObservableObject {
    @Published var messagesByUserId: [Message] = []
    @Published var message: Message?
    @Published var user: User?
    @Published var currentState: ViewState = .none
    @Published var searchQuery: String = ""
    @Published var groupID: Int? = nil
    @Published var groupedMessages: [Chat] = []
    
    @Published var webSocketManager = WebSocketManager.shared
    
    var userId: Int? = {
        return UserDefaults.standard.integer(forKey: "userId")
    }()
    
    init() {
        getUserById(userId: /*userId*/ 1)
        getMessagesByUserId(userId: 1/* ?? 0*/)
        setUpWebSocket()
    }
    
    func getMessagesByUserId(userId: Int) {
        currentState = .loading
        Task {
            do {
                let response = try await APIClient.shared.callWithStatusCode(.getMessagesByUserId(userId: userId), decodeTo: [Message].self)
                DispatchQueue.main.async {
                    self.messagesByUserId = response.data
                    self.currentState = .none
                    self.groupMessages()
                }
            } catch {
                print("Error fetching messages by userId:", error.localizedDescription)
                currentState = .error(error.localizedDescription)
            }
        }
    }
    
    func getUserById(userId: Int? = nil) {
        Task {
            do {
                let response = try await APIClient.shared.callWithStatusCode(.getUserById(id: userId ?? 0), decodeTo: User.self)
                DispatchQueue.main.async {
                    self.user = response.data
                    self.currentState = .none
                    UserDefaults.standard.set(self.user?.userID, forKey: "userId")
                }
            } catch {
                print(error)
                print(error.localizedDescription)
                print("error in fetching user by id")
                currentState = .error(error.localizedDescription)
            }
        }
    }
    
    func sendMessage(content: String, recipientId: Int) {
        guard let senderId = userId else {
            print("Sender ID is missing!")
            return
        }
        let message = Message(id: UUID().hashValue, senderID: senderId, recipientID: recipientId, groupID: groupID, messageContent: content, createdAt: getCurrentTimestamp(), mediaType: "")
        WebSocketManager.shared.connect()
        WebSocketManager.shared.sendTextMessage(content, senderId: senderId, recipientId: recipientId)
        DispatchQueue.main.async {
            self.messagesByUserId.append(message)
        }
    }
    
    
    func setUpWebSocket() {
        webSocketManager.connect()
        
        webSocketManager.onMessageReceived = { [weak self] message in
            self?.handleIncomingMessage(message)
        }
    }
    
    func groupMessages() {
        var groupedDict: [Int: [Message]] = [:]
        
        for message in messagesByUserId {
            let key = message.groupID ?? message.recipientID ?? -1
            if groupedDict[key] != nil {
                groupedDict[key]?.append(message)
            } else {
                groupedDict[key] = [message]
            }
        }
        
        self.groupedMessages = groupedDict.map { (key, messages) in
            let chat = Chat(id: key, messages: messages)
            return chat
        }
        
        print("Grouped Messages: \(self.groupedMessages)")
    }
    
    func handleIncomingMessage(_ message: Message) {
        print("Received message: \(message)")
        DispatchQueue.main.async {
            self.messagesByUserId.append(message)
            print("Messages By User ID: \(self.messagesByUserId)")
            self.groupMessages()
        }
    }
    
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

struct MessagesView: View {
    @StateObject var viewModel = MessageViewModel()
    @State var showMessageDetail: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search", text: $viewModel.searchQuery)
                    .padding(10)
                    .background(Color.accent.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(.horizontal, 24)
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.groupedMessages, id: \.self) { chat in
                            Button {
                                showMessageDetail = true
                                print("detail tapped: \(chat.id)")
                            } label: {
                                ChatRow(chat: chat)
                            }
                        }
                    }
                    NavigationLink(
                        destination: MessageDetails(viewModel: viewModel, messages: viewModel.messagesByUserId),
                        isActive: $showMessageDetail
                    ) {
                        EmptyView()
                    }
                }
                .padding(.horizontal, 24)
            }
            .navigationBarTitle("Chats", displayMode: .inline)
        }
    }
}

struct ChatRow: View {
    let chat: Chat
    
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
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45)
                    .foregroundColor(.gray.opacity(0.5))
            }
            Divider()
        }
    }
}

struct MessageDetails: View {
    
    @StateObject var viewModel: MessageViewModel
    var messages: [Message]
    @State private var newMessage: String = ""
    @State private var isScrolledToBottom: Bool = true
    @FocusState private var isTextFieldFocused: Bool 
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(messages, id: \.id) { message in
                            MessageRow(message: message)
                                .id(message.id)
                                .padding(.horizontal)
                        }
                    }
                    .onChange(of: messages.count) { _ in
                        if isScrolledToBottom {
                            withAnimation {
                                proxy.scrollTo(messages.last?.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }
            
            HStack {
                TextField("Type a message...", text: $newMessage)
                    .padding(12)
                    .background(Color.accent.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(.horizontal, 24)
                    .focused($isTextFieldFocused)
                    .onChange(of: newMessage) { _ in
                        isScrolledToBottom = false
                    }
                
                Button(action: sendMessage) {
                    Text("Send")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding(.trailing, 24)
                .disabled(newMessage.isEmpty)
            }
            .padding(.bottom, 16)
        }
        .onAppear {
            if messages.count > 0 {
                isScrolledToBottom = true
            }
        }
        .onChange(of: newMessage) { _ in
            if isScrolledToBottom {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isScrolledToBottom = true
                }
            }
        }
    }
    
    func sendMessage() {
        guard !newMessage.isEmpty else { return }
        
        let recipientId = viewModel.groupID ?? 0
        
        viewModel.sendMessage(content: newMessage, recipientId: recipientId)
        
        newMessage = ""
        
        isTextFieldFocused = true
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
