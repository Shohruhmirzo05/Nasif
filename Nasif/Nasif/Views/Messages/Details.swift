//
//  Details.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 13/02/25.
//

import SwiftUI

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
                        ForEach(messages, id: \.self) { message in
                            MessageRow(message: message)
                                .id(message.id ?? 1)
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
        
        let recipientId = viewModel.groups.first?.id ?? 0
        
        viewModel.sendMessage(content: newMessage, recipientId: recipientId)
        
        newMessage = ""
        
        isTextFieldFocused = true
    }
}
