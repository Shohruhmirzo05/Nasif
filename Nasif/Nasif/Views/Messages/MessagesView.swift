//
//  MessagesView.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 09/01/25.
//

import SwiftUI

struct GroupModel: Codable, Identifiable, Hashable {
    let id: Int?
    let groupName: String?
    let adminId: Int?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id =  "group_id"
        case groupName = "group_name"
        case adminId = "admin_id"
        case createdAt = "created_at"
    }
}

@MainActor
class MessageViewModel: ObservableObject {
    @Published var messagesByUserId: [Int: [Message]] = [:]
    @Published var groupMessages: [Int: [Message]] = [:]
    @Published var currentState: ViewState = .none
    @Published var groups: [GroupModel] = []
    @Published var currentChatType: ChatType = .personal
    @Published var currentChatId: Int?
    @Published var searchQuery: String = ""
    
    private var webSocketManager = WebSocketManager.shared
    
    var userId: Int? {
        UserDefaults.standard.userId
    }
    
    init() {
        setupWebSocket()
        if let userId = userId {
            getMessagesByUserId(userId: userId)
        }
        getGroups()
    }
    
    private func setupWebSocket() {
        webSocketManager.onMessageReceived = { [weak self] message in
            self?.handleIncomingMessage(message)
        }
        webSocketManager.connect()
    }
    
    func handleIncomingMessage(_ message: Message) {
        if let groupId = message.groupID {
            // Handle group message
            var messages = groupMessages[groupId] ?? []
            messages.append(message)
            groupMessages[groupId] = messages
        } else {
            // Handle personal message
            let chatId = message.senderID == userId ? message.recipientID ?? 0 : message.senderID
            var messages = messagesByUserId[chatId ?? 0] ?? []
            messages.append(message)
            messagesByUserId[chatId ?? 0] = messages
        }
    }
    
    func getMessagesForCurrentChat() -> [Message] {
        guard let currentChatId = currentChatId else { return [] }
        
        switch currentChatType {
        case .personal:
            return messagesByUserId[currentChatId] ?? []
        case .group:
            return groupMessages[currentChatId] ?? []
        }
    }
    
    func sendMessage(content: String, recipientId: Int) {
        guard let senderId = userId else { return }
        
        let groupId = currentChatType == .group ? currentChatId : nil
        
        webSocketManager.sendTextMessage(
            content,
            senderId: senderId,
            recipientId: recipientId,
            groupId: groupId
        )
    }
    
    func setCurrentChat(type: ChatType, id: Int) {
        currentChatType = type
        currentChatId = id
        
        if type == .group {
            fetchMessagesForGroup(groupId: id)
        }
    }
    
    func fetchMessagesForGroup(groupId: Int) {
            Task {
                do {
                    let response = try await APIClient.shared.callWithStatusCode(.getMessagesByGroupId(groupId: groupId), decodeTo: [Message].self)
                    DispatchQueue.main.async {
                        self.groupMessages[groupId] = response.data
                    }
                } catch {
                    print("Error fetching messages for group \(groupId):", error.localizedDescription)
                }
            }
        }
    
    func getGroups() {
        Task {
            do {
                let response = try await APIClient.shared.callWithStatusCode(.getGroups, decodeTo: [GroupModel].self)
                DispatchQueue.main.async {
                    self.groups = response.data
                }
            } catch {
                print("Error fetching groups:", error.localizedDescription)
            }
        }
    }
    
    func getMessagesByUserId(userId: Int) {
            currentState = .loading
            Task {
                do {
                    let response = try await APIClient.shared.callWithStatusCode(.getMessagesByUserId(userId: userId), decodeTo: [Message].self)
                    DispatchQueue.main.async {
                        self.messagesByUserId[userId] = response.data
                        self.currentState = .none
                    }
                } catch {
                    print("Error fetching messages by userId:", error.localizedDescription)
                    currentState = .error(error.localizedDescription)
                }
            }
        }
    
    enum ChatType {
        case personal
        case group
    }
    
    enum ViewState: Equatable {
        case loading, none, error(_ description: String)
    }
}


struct MessagesView: View {
    @StateObject var viewModel = MessageViewModel()
    @State var showMessageDetail: Bool = false
    @State var showGrupoDetail: Bool = false
    @State var selectedGroup: GroupModel?
    
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
                        ForEach(viewModel.messagesByUserId.keys.sorted(), id: \.self) { userId in
                                   let messages = viewModel.messagesByUserId[userId] ?? []
                                   let chat = Chat(id: userId, messages: messages)

                                   Button {
                                       viewModel.setCurrentChat(type: .personal, id: userId)
                                       showMessageDetail = true
                                       print("Direct chat tapped: \(chat.id)")
                                   } label: {
                                       ChatRow(chat: chat, chatImage: "person.circle.fill")
                                   }
                               }
                        ForEach(viewModel.groups, id: \.id) { group in
                            Button {
                                selectedGroup = group
                                showMessageDetail = true
                                print("Group tapped: \(group.id ?? 0)")
                            } label: {
                                ChatRow(chat: Chat(id: group.id ?? -1, messages: []), chatImage: "rectangle.3.group.bubble")
                                    .overlay(Text(group.groupName ?? "")
                                        .font(.headline)
                                        .padding(.leading, 10), alignment: .leading)
                            }
                        }
                    }
                    NavigationLink(
                        destination: MessageDetails(
                            viewModel: viewModel,
                            messages: viewModel.getMessagesForCurrentChat()
                        ),
                        isActive: $showMessageDetail
                    ) {
                        EmptyView()
                    }

                    NavigationLink(
                        destination: GroupMessageDetails(viewModel: viewModel, group: selectedGroup ?? .init(id: 0, groupName: "", adminId: 0, createdAt: "")),
                        isActive: $showGrupoDetail
                    ) {
                        EmptyView()
                    }
                    
                }
                .padding(.horizontal, 24)
                .safeAreaInset(edge: .bottom, content: CreateGroupButton)
            }
            .navigationBarTitle("Chats", displayMode: .inline)
        }
    }
    
    @ViewBuilder func CreateGroupButton() -> some View {
        HStack {
            Spacer()
            Button {
                //            showAddlistingView = true
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(12)
                    .background(Color.gray)
                    .clipShape(Circle())
                    .foregroundStyle(.white)
                    .padding()
            }
        }
    }
    
    func createGroup() {
        // Logic to create a new group
        print("Create group tapped")
    }
}



//@MainActor
//class MessageViewModel: ObservableObject {
////    @Published var messagesByUserId: [Message] = []
//    @Published var messagesByUserId: [Int: [Message]] = [:]
//    @Published var groupMessages: [Int: [Message]] = [:]
//
//    @Published var message: Message?
//    @Published var user: User?
//    @Published var currentState: ViewState = .none
//    @Published var searchQuery: String = ""
//    @Published var groupID: Int? = nil
////    @Published var groupedMessages: [Chat] = []
//    @Published var groups: [GroupModel] = []
//
//    @Published var webSocketManager = WebSocketManager.shared
//
//    @Published var groupMessagesDetail: [Chat] = []
//    @Published var currentChatType: ChatType = .personal
//    @Published var currentGroupId: Int?
//
//    @Published var currentChatId: Int?
//
//    enum ChatType {
//        case personal
//        case group
//    }
//    var userId: Int? = {
//        return UserDefaults.standard.integer(forKey: "userId")
//    }()
//
//    init() {
////        getUserById(userId: /*userId*/ 1)
////        getMessagesByUserId(userId: 1/* ?? 0*/)
////        setUpWebSocket()
////        getGroups()
//        setupWebSocket()
//        if let userId = userId {
//            getMessagesByUserId(userId: userId)
//        }
//        getGroups()
//    }
//
//    private func setupWebSocket() {
//          webSocketManager.onMessageReceived = { [weak self] message in
//              self?.handleIncomingMessage(message)
//          }
//          webSocketManager.connect()
//      }
//
//
//    func fetchMessagesForGroup(groupId: Int) {
//        Task {
//            do {
//                let response = try await APIClient.shared.callWithStatusCode(.getMessagesByGroupId(groupId: groupId), decodeTo: [Message].self)
//                DispatchQueue.main.async {
//                    if let index = self.groupMessagesDetail.firstIndex(where: { $0.id == groupId }) {
//                        self.groupMessagesDetail[index].messages = response.data
//                    } else {
//                        let newChat = Chat(id: groupId, messages: response.data)
//                        self.groupMessagesDetail.append(newChat)
//                    }
//                }
//            } catch {
//                print("Error fetching messages for group \(groupId):", error.localizedDescription)
//            }
//        }
//    }
//
//    func getGroups() {
//        Task {
//            do {
//                let response = try await APIClient.shared.callWithStatusCode(.getGroups, decodeTo: [GroupModel].self)
//                DispatchQueue.main.async {
//                    self.groups = response.data
//                }
//            } catch {
//                print("Error fetching groups:", error.localizedDescription)
//            }
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
//                    self.groupMessages()
//                }
//            } catch {
//                print("Error fetching messages by userId:", error.localizedDescription)
//                currentState = .error(error.localizedDescription)
//            }
//        }
//    }
//
//    func getUserById(userId: Int? = nil) {
//        Task {
//            do {
//                let response = try await APIClient.shared.callWithStatusCode(.getUserById(id: userId ?? 0), decodeTo: User.self)
//                DispatchQueue.main.async {
//                    self.user = response.data
//                    self.currentState = .none
//                    UserDefaults.standard.set(self.user?.userID, forKey: "userId")
//                }
//            } catch {
//                print(error)
//                print(error.localizedDescription)
//                print("error in fetching user by id")
//                currentState = .error(error.localizedDescription)
//            }
//        }
//    }
//
//    func sendMessage(content: String, recipientId: Int) {
//            guard let senderId = userId else { return }
//
//            let groupId = currentChatType == .group ? currentChatId : nil
//
//            webSocketManager.sendTextMessage(
//                content,
//                senderId: senderId,
//                recipientId: recipientId,
//                groupId: groupId
//            )
//        }
////    func sendMessage(content: String, recipientId: Int) {
////        guard let senderId = userId else {
////            print("Sender ID is missing!")
////            return
////        }
////        let message = Message(id: UUID().hashValue, senderID: senderId, recipientID: recipientId, groupID: groupID, messageContent: content, createdAt: getCurrentTimestamp(), mediaType: "")
////        WebSocketManager.shared.connect()
////        WebSocketManager.shared.sendTextMessage(content, senderId: senderId, recipientId: recipientId, groupId: groupID)
////        DispatchQueue.main.async {
////            self.messagesByUserId.append(message)
////        }
////    }
//
//
//    func setUpWebSocket() {
//        webSocketManager.connect()
//
//        webSocketManager.onMessageReceived = { [weak self] message in
//            self?.handleIncomingMessage(message)
//        }
//    }
//
//    func groupMessages() {
//        var groupedDict: [Int: [Message]] = [:]
//
//        for message in messagesByUserId {
//            let key = message.groupID ?? message.recipientID ?? -1
//            if groupedDict[key] != nil {
//                groupedDict[key]?.append(message)
//            } else {
//                groupedDict[key] = [message]
//            }
//        }
//
//        self.groupedMessages = groupedDict.map { (key, messages) in
//            let chat = Chat(id: key, messages: messages)
//            return chat
//        }
//
//        print("Grouped Messages: \(self.groupedMessages)")
//    }
//
//    func getMessagesForCurrentChat() -> [Message] {
//           guard let currentChatId = currentChatId else { return [] }
//
//           switch currentChatType {
//           case .personal:
//               return messagesByUserId[currentChatId] ?? []
//           case .group:
//               return groupMessages[currentChatId] ?? []
//           }
//       }
//
//    func handleIncomingMessage(_ message: Message) {
//          if let groupId = message.groupID {
//              // Handle group message
//              var messages = groupMessages[groupId] ?? []
//              messages.append(message)
//              groupMessages[groupId] = messages
//          } else {
//              // Handle personal message
//              let chatId = message.senderID == userId ? message.recipientID ?? 0 : message.senderID
//              var messages = messagesByUserId[chatId] ?? []
//              messages.append(message)
//              messagesByUserId[chatId] = messages
//          }
//      }
//
////    func handleIncomingMessage(_ message: Message) {
////        print("Received message: \(message)")
////        DispatchQueue.main.async {
////            if let groupId = message.groupID {
////                // Handle group message
////                if let index = self.groupMessagesDetail.firstIndex(where: { $0.id == groupId }) {
////                    self.groupMessagesDetail[index].messages.append(message)
////                } else {
////                    // Create a new group chat if it doesn't exist
////                    let newChat = Chat(id: groupId, messages: [message])
////                    self.groupMessagesDetail.append(newChat)
////                }
////            } else {
////                // Handle personal message
////                self.messagesByUserId.append(message)
////            }
////        }
////    }
//
//    private func getCurrentTimestamp() -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        return formatter.string(from: Date())
//    }
//
//    var filteredMessages: [Message] {
//        switch currentChatType {
//        case .personal:
//            return messagesByUserId
//        case .group:
//            if let groupId = currentGroupId,
//               let groupChat = groupMessagesDetail.first(where: { $0.id == groupId }) {
//                return groupChat.messages
//            }
//            return []
//        }
//    }
//
////    func setCurrentChatType(to type: ChatType, groupId: Int? = nil) {
////        currentChatType = type
////        currentGroupId = groupId
////    }
//
//    func setCurrentChat(type: ChatType, id: Int) {
//          currentChatType = type
//          currentChatId = id
//
//          if type == .group {
//              fetchMessagesForGroup(groupId: id)
//          }
//      }
//
//    enum ViewState: Equatable {
//        case loading, none, error(_ description: String)
//    }
//
//}
