//
//  GroupDetails.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 13/02/25.
//

import SwiftUI


import SwiftUI

struct GroupMessageDetails: View {
    @StateObject var viewModel: MessageViewModel
    var group: GroupModel
    @State private var newMessage: String = ""
    @State private var isScrolledToBottom: Bool = true
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.getMessagesForCurrentChat(), id: \.id) { message in
                            MessageRow(message: message)
                                .id(message.id)
                                .padding(.horizontal)
                        }
                    }
                    .onChange(of: viewModel.getMessagesForCurrentChat().count) { _ in
                        if isScrolledToBottom {
                            withAnimation {
                                proxy.scrollTo(viewModel.getMessagesForCurrentChat().last?.id, anchor: .bottom)
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
            viewModel.setCurrentChat(type: .group, id: group.id ?? 0)
            viewModel.fetchMessagesForGroup(groupId: group.id ?? 0)
        }
    }

    func sendMessage() {
        guard !newMessage.isEmpty else { return }

        let groupId = viewModel.currentChatId ?? 0
        viewModel.sendMessage(content: newMessage, recipientId: groupId)

        newMessage = ""
        isTextFieldFocused = true
    }
}

//struct GroupMessageDetails: View {
//    @StateObject var viewModel: MessageViewModel
//    var group: GroupModel
//    @State private var newMessage: String = ""
//    @State private var isScrolledToBottom: Bool = true
//    @FocusState private var isTextFieldFocused: Bool
//
//    var body: some View {
//        VStack {
//            ScrollViewReader { proxy in
//                ScrollView {
//                    LazyVStack {
//                        ForEach(viewModel.filteredMessages, id: \.id) { message in
//                            MessageRow(message: message)
//                                .id(message.id)
//                                .padding(.horizontal)
//                        }
//                    }
//                    .onChange(of: viewModel.filteredMessages.count) { _ in
//                        if isScrolledToBottom {
//                            withAnimation {
//                                proxy.scrollTo(viewModel.filteredMessages.last?.id, anchor: .bottom)
//                            }
//                        }
//                    }
//                }
//            }
//
//            HStack {
//                TextField("Type a message...", text: $newMessage)
//                    .padding(12)
//                    .background(Color.accent.opacity(0.1))
//                    .clipShape(RoundedRectangle(cornerRadius: 24))
//                    .padding(.horizontal, 24)
//                    .focused($isTextFieldFocused)
//                    .onChange(of: newMessage) { _ in
//                        isScrolledToBottom = false
//                    }
//
//                Button(action: sendMessage) {
//                    Text("Send")
//                        .padding(.horizontal, 16)
//                        .padding(.vertical, 10)
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .clipShape(RoundedRectangle(cornerRadius: 20))
//                }
//                .padding(.trailing, 24)
//                .disabled(newMessage.isEmpty)
//            }
//            .padding(.bottom, 16)
//        }
//        .onAppear {
//            viewModel.setCurrentChatType(to: .group, groupId: group.id)
//            viewModel.fetchMessagesForGroup(groupId: group.id ?? 0)
//            if viewModel.filteredMessages.count > 0 {
//                isScrolledToBottom = true
//            }
//        }
//        .onChange(of: newMessage) { _ in
//            if isScrolledToBottom {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    isScrolledToBottom = true
//                }
//            }
//        }
//    }
//
//    func sendMessage() {
//        guard !newMessage.isEmpty else { return }
//
//        let recipientId = viewModel.currentGroupId ?? 0
//        viewModel.sendMessage(content: newMessage, recipientId: recipientId) // Send message to group
//
//        newMessage = ""
//        isTextFieldFocused = true
//    }
//}

//struct GroupMessageDetails: View {
//    @StateObject var viewModel: MessageViewModel
//    var group: GroupModel
//    @State private var newMessage: String = ""
//    @State private var isScrolledToBottom: Bool = true
//    @FocusState private var isTextFieldFocused: Bool
//    
//    var body: some View {
//        VStack {
//            ScrollViewReader { proxy in
//                ScrollView {
//                    LazyVStack {
//                        ForEach(viewModel.groupedMessages.first(where: { $0.id == group.id })?.messages ?? [], id: \.id) { message in
//                            MessageRow(message: message)
//                                .id(message.id)
//                                .padding(.horizontal)
//                        }
//                    }
//                    .onChange(of: viewModel.groupedMessages.count) { _ in
//                        if isScrolledToBottom {
//                            withAnimation {
//                                proxy.scrollTo(viewModel.groupedMessages.first(where: { $0.id == group.id })?.messages.last?.id, anchor: .bottom)
//                            }
//                        }
//                    }
//                }
//            }
//            
//            HStack {
//                TextField("Type a message...", text: $newMessage)
//                    .padding(12)
//                    .background(Color.accent.opacity(0.1))
//                    .clipShape(RoundedRectangle(cornerRadius: 24))
//                    .padding(.horizontal, 24)
//                    .focused($isTextFieldFocused)
//                    .onChange(of: newMessage) { _ in
//                        isScrolledToBottom = false
//                    }
//                
//                Button(action: sendMessage) {
//                    Text("Send")
//                        .padding(.horizontal, 16)
//                        .padding(.vertical, 10)
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .clipShape(RoundedRectangle(cornerRadius: 20))
//                }
//                .padding(.trailing, 24)
//                .disabled(newMessage.isEmpty)
//            }
//            .padding(.bottom, 16)
//        }
//        .onAppear {
//            if viewModel.groupedMessages.first(where: { $0.id == group.id })?.messages.count ?? 0 > 0 {
//                isScrolledToBottom = true
//            }
//        }
//        .onChange(of: newMessage) { _ in
//            if isScrolledToBottom {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    isScrolledToBottom = true
//                }
//            }
//        }
//    }
//    
//    func sendMessage() {
//        guard !newMessage.isEmpty else { return }
//        
//        let recipientId = viewModel.groupID ?? 0
//        
//        viewModel.sendMessage(content: newMessage, recipientId: recipientId) // Send message to group
//        
//        newMessage = ""
//        
//        isTextFieldFocused = true
//    }
//}
//
//
