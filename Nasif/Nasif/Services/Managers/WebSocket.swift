//
//  WebSocket.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 07/02/25.
//

import SwiftUI

//
//  WebSocket.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 07/02/25.
//

//import SwiftUI
//
//class WebSocketManager: NSObject {
//    static let shared = WebSocketManager()
//    var webSocket: URLSessionWebSocketTask?
//    var onMessageReceived: ((Message) -> Void)?
//    private var messageQueue: [[String: Any]] = []
//    
//    private var isConnected = false
//    private var reconnectTimer: Timer?
//    
//    private override init() {}
//    
//    func connect() {
//        guard let url = URL(string: "wss://appnasif.com:8081/ws") else {
//            print("❌ Invalid WebSocket URL")
//            return
//        }
//
//        // Cancel any existing WebSocket before reconnecting
//        if let existingWebSocket = webSocket {
//            print("🔌 Closing existing WebSocket connection before reconnecting...")
//            existingWebSocket.cancel(with: .goingAway, reason: nil)
//        }
//
//        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
//        webSocket = urlSession.webSocketTask(with: url)
//
//        print("🔌 Attempting to connect WebSocket...")
//        webSocket?.resume()
//
//        listenForMessages()
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            if let state = self.webSocket?.state, state == .running {
//                self.isConnected = true
//                self.reconnectAttempts = 0  // ✅ Reset reconnect attempts
//                self.setupPingTimer()
//                print("✅ WebSocket successfully connected")
//
//                // Send all queued messages
//                for message in self.messageQueue {
//                    self.sendMessage(message)
//                }
//                self.messageQueue.removeAll()
//            } else {
//                print("❌ WebSocket failed to connect, retrying...")
//                self.reconnectIfNeeded()
//            }
//        }
//    }
//
//
////    func connect() {
////        guard let url = URL(string: "wss://appnasif.com:8081/ws") else {
////            print("Invalid URL")
////            return
////        }
////        
////        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
////        webSocket = urlSession.webSocketTask(with: url)
////        
////        print("Attempting to connect WebSocket...")
////        webSocket?.resume()
////
////        listenForMessages()
////        
////        // Mark connected only after successful handshake
////        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
////            if let state = self.webSocket?.state, state == .running {
////                self.isConnected = true
////                print("WebSocket successfully connected")
////                self.setupPingTimer()
////                
////                // Send queued messages
////                for message in self.messageQueue {
////                    self.sendMessage(message)
////                }
////                self.messageQueue.removeAll()
////            } else {
////                print("WebSocket failed to connect, retrying...")
////                self.reconnectIfNeeded()
////            }
////        }
////    }
//    
//    private func setupPingTimer() {
//        // Send ping every 30 seconds to keep connection alive
//        reconnectTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
//            self?.sendPing()
//        }
//    }
//    
//    private func sendPing() {
//        let pingMessage = ["type": "ping"]
//        sendMessage(pingMessage)
//    }
//
//    func listenForMessages() {
//        Task {
//            while isConnected {
//                do {
//                    guard let webSocket = self.webSocket else { break }
//                    
//                    let message = try await webSocket.receive()
//                    switch message {
//                    case .data(let data):
//                        handleReceivedData(data)
//                    case .string(let string):
//                        if let data = string.data(using: .utf8) {
//                            handleReceivedData(data)
//                        }
//                    @unknown default:
//                        break
//                    }
//                } catch {
//                    handleDisconnection(error: error)
//                }
//            }
//        }
//    }
//    
//    private func handleReceivedData(_ data: Data) {
//        do {
//            let message = try JSONDecoder().decode(Message.self, from: data)
//            DispatchQueue.main.async {
//                self.onMessageReceived?(message)
//            }
//        } catch {
//            print("Error decoding message: \(error)")
//        }
//    }
//    
//    private func handleDisconnection(error: Error) {
//        isConnected = false
//        print("WebSocket disconnected: \(error)")
//        
//        // Attempt to reconnect after 5 seconds
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
//            self?.connect()
//        }
//    }
//    
//    func sendMessage(_ message: [String: Any]) {
//        guard let webSocket = webSocket else {
//            print("⚠️ WebSocket is nil. Queuing message...")
//            messageQueue.append(message)
//            reconnectIfNeeded()
//            return
//        }
//
//        // ✅ Ensure WebSocket is actually running before sending
//        if webSocket.state == .running {
//            do {
//                let data = try JSONSerialization.data(withJSONObject: message, options: [])
//                let webSocketMessage = URLSessionWebSocketTask.Message.data(data)
//                webSocket.send(webSocketMessage) { error in
//                    if let error = error {
//                        print("❌ Error sending message: \(error.localizedDescription)")
//                        self.reconnectIfNeeded()
//                    } else {
//                        print("✅ Message sent successfully: \(message)")
//                    }
//                }
//            } catch {
//                print("❌ Error serializing message: \(error)")
//            }
//        } else {
//            print("⚠️ WebSocket is not connected. Queuing message...")
//            messageQueue.append(message)
//            reconnectIfNeeded()
//        }
//    }
//
//
////    func sendMessage(_ message: [String: Any]) {
////        guard let webSocket = webSocket else {
////            print("WebSocket is nil. Queuing message...")
////            messageQueue.append(message)
////            reconnectIfNeeded()
////            return
////        }
////
////        if webSocket.state == .running {
////            do {
////                let data = try JSONSerialization.data(withJSONObject: message, options: [])
////                let webSocketMessage = URLSessionWebSocketTask.Message.data(data)
////                webSocket.send(webSocketMessage) { error in
////                    if let error = error {
////                        print("Error sending message: \(error)")
////                        self.reconnectIfNeeded()
////                    } else {
////                        print("Message sent successfully: \(message)")
////                    }
////                }
////            } catch {
////                print("Error serializing message: \(error)")
////            }
////        } else {
////            print("WebSocket is disconnected. Queuing message...")
////            messageQueue.append(message)
////            reconnectIfNeeded()
////        }
////    }
//
//    func sendTextMessage(_ messageContent: String, senderId: Int, recipientId: Int, groupId: Int?) {
//        let message: [String: Any] = [
//            "type": "message",
//            "sender_id": senderId,
//            "recipient_id": recipientId,
//            "group_id": groupId as Any,
//            "message_content": messageContent,
//            "media_type": "text",
//            "created_at": getCurrentTimestamp()
//        ]
//        
//        sendMessage(message)
//    }
//    
//    private func getCurrentTimestamp() -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        return formatter.string(from: Date())
//    }
//
//    func sendMediaMessage(mediaData: Data, senderId: Int, recipientId: Int, mediaType: String, mediaName: String, groupId: Int?, completion: @escaping (Result<String, Error>) -> Void) {
//        var request = URLRequest(url: URL(string: "https://appnasif.com/appnasif_api/ws/upload_media")!)
//        request.httpMethod = "POST"
//        
//        var body = Data()
//        let boundary = "Boundary-\(UUID().uuidString)"
//        
//        let fileHeader = "--\(boundary)\r\n" +
//        "Content-Disposition: form-data; name=\"file\"; filename=\"\(mediaName)\"\r\n" +
//        "Content-Type: \(mediaType)\r\n\r\n"
//
//        if let headerData = fileHeader.data(using: .utf8) {
//            body.append(headerData)
//        }
//        
//        body.append(mediaData)
//        
//        let endingBoundary = "\r\n--\(boundary)--\r\n"
//        
//        if let boundaryData = endingBoundary.data(using: .utf8) {
//            body.append(boundaryData)
//        }
//        
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        request.httpBody = body
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error uploading media: \(error)")
//                completion(.failure(error))
//                return
//            }
//            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
//                if let mediaURL = String(data: data, encoding: .utf8) {
//                    completion(.success(mediaURL))
//                    
//                    // Now send the uploaded media URL over WebSocket
//                    self.sendTextMessage("Sent media: \(mediaURL)", senderId: senderId, recipientId: recipientId, groupId: groupId)
//                } else {
//                    completion(.failure(NSError(domain: "InvalidResponse", code: -1, userInfo: nil)))
//                }
//            }
//        }
//        
//        task.resume()
//    }
//
//    private var reconnectAttempts = 0
//    private let maxReconnectDelay = 60.0  // Stop increasing delay after 60 seconds
//
//    func reconnectIfNeeded() {
//        guard !isConnected else { return }
//
//        let retryDelay = min(pow(2.0, Double(reconnectAttempts)), maxReconnectDelay)  // Exponential backoff
//        reconnectAttempts += 1
//
//        print("🔄 Attempting WebSocket reconnection in \(Int(retryDelay)) seconds (Attempt \(reconnectAttempts))...")
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + retryDelay) { [weak self] in
//            guard let self = self, !self.isConnected else { return }
//            self.connect()
//        }
//    }
//
//
////    func reconnectIfNeeded() {
////        guard !isConnected else { return }
////
////        let retryDelay = 5.0 // Retry after 5 seconds
////        print("Attempting WebSocket reconnection in \(retryDelay) seconds...")
////        
////        DispatchQueue.main.asyncAfter(deadline: .now() + retryDelay) { [weak self] in
////            guard let self = self, !self.isConnected else { return }
////            self.connect()
////        }
////    }
//
//    func checkWebSocketState() {
//        guard let webSocket = webSocket else { return }
//        
//        switch webSocket.state {
//        case .running:
//            print("WebSocket is running.")
//        case .suspended:
//            print("WebSocket is suspended.")
//        case .canceling:
//            print("WebSocket is canceling.")
//        case .completed:
//            print("WebSocket connection is completed (closed).")
//        default:
//            print("Unknown WebSocket state: \(webSocket.state)")
//        }
//    }
//
//    func closeConnection() {
//        guard let webSocket = self.webSocket else {
//            print("WebSocket is already closed or not open.")
//            return
//        }
//        webSocket.cancel(with: .goingAway, reason: nil)
//        print("WebSocket connection closed.")
//    }
//}
//
//// WebSocket Delegate
//extension WebSocketManager: URLSessionWebSocketDelegate {
//    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
//        print("✅ WebSocket is open and ready.")
//        isConnected = true
//        reconnectAttempts = 0  // ✅ Reset backoff delay on successful connection
//        setupPingTimer()
//    }
//    
//    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
//        print("⚠️ WebSocket closed with code: \(closeCode.rawValue). Reconnecting...")
//        isConnected = false
//        reconnectIfNeeded()
//    }
//}
//




//MARK: Mine

class WebSocketManager {
    static let shared = WebSocketManager()
    var webSocket: URLSessionWebSocketTask?
    var onMessageReceived: ((Message) -> Void)?
    private var messageQueue: [[String: Any]] = []
    
    private var isConnected = false
    private var reconnectTimer: Timer?
    
    private init() {}
    
    func connect() {
        guard let url = URL(string: "wss://appnasif.com:8081/ws") else {
            print("Invalid URL")
            return
        }
        
        let urlSession = URLSession(configuration: .default)
        webSocket = urlSession.webSocketTask(with: url)
        
        print("WebSocket state before connection attempt: \(String(describing: webSocket?.state))")
        webSocket?.resume()
        print("WebSocket state after connection attempt: \(String(describing: webSocket?.state))")

        listenForMessages()
        isConnected = true
        setupPingTimer()
        print("websocket connected successfully: \(url)")
        print("WebSocket state: \(String(describing: webSocket?.state))")
        for message in messageQueue {
                    sendMessage(message)
                }
                messageQueue.removeAll()
    }
    
    private func setupPingTimer() {
            // Send ping every 30 seconds to keep connection alive
            reconnectTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
                self?.sendPing()
            }
        }
    private func sendPing() {
            let pingMessage = ["type": "ping"]
            sendMessage(pingMessage)
        }
    
    func receiveMessages() {
        webSocket?.receive { result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received text message: \(text)")
                case .data(let data):
                    print("Received data message: \(data)")
                @unknown default:
                    print("Unknown message type")
                }
                self.receiveMessages()
                
            case .failure(let error):
                print("Error receiving message: \(error.localizedDescription)")
            }
        }
    }
    
    func listenForMessages() {
          Task {
              while isConnected {
                  do {
                      guard let webSocket = self.webSocket else { break }
                      
                      let message = try await webSocket.receive()
                      switch message {
                      case .data(let data):
                          handleReceivedData(data)
                      case .string(let string):
                          if let data = string.data(using: .utf8) {
                              handleReceivedData(data)
                          }
                      @unknown default:
                          break
                      }
                  } catch {
                      handleDisconnection(error: error)
                  }
              }
          }
      }
    
    private func handleReceivedData(_ data: Data) {
         do {
             let message = try JSONDecoder().decode(Message.self, from: data)
             DispatchQueue.main.async {
                 self.onMessageReceived?(message)
             }
         } catch {
             print("Error decoding message: \(error)")
         }
     }
     
     private func handleDisconnection(error: Error) {
         isConnected = false
         print("WebSocket disconnected: \(error)")
         
         // Attempt to reconnect after 5 seconds
         DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
             self?.connect()
         }
     }
    
     
//    func listenForMessages() {
//            Task {
//                while true {
//                    do {
//                        guard let webSocket = self.webSocket, webSocket.state == .running else {
//                            print("WebSocket is closed or not open, attempting to reconnect.")
//                            self.connect()
//                            continue
//                        }
//                        
//                        let message = try await webSocket.receive()
//                        switch message {
//                        case .data(let data):
//                            if let decodedMessage = try? JSONDecoder().decode(Message.self, from: data) {
//                                DispatchQueue.main.async {
//                                    // Check if the message is for a group or a personal chat
//                                    if let groupId = decodedMessage.groupID {
//                                        // Handle group message
//                                        self.onMessageReceived?(decodedMessage)
//                                    } else {
//                                        // Handle personal message
//                                        self.onMessageReceived?(decodedMessage)
//                                    }
//                                }
//                            }
//                        case .string(_):
//                            break
//                        @unknown default:
//                            break
//                        }
//                    } catch {
//                        print("WebSocket receive error:", error)
//                    }
//                }
//            }
//        }

    func sendMessage(_ message: [String: Any]) {
        guard let webSocket = webSocket else {
            print("WebSocket instance is nil. Cannot send message: \(message)")
            return
        }

        if webSocket.state == .running {
            do {
                let data = try JSONSerialization.data(withJSONObject: message, options: [])
                let webSocketMessage = URLSessionWebSocketTask.Message.data(data)
                webSocket.send(webSocketMessage) { error in
                    if let error = error {
                        print("Error sending message: \(error.localizedDescription)")
                        self.reconnectIfNeeded()
                    } else {
                        print("Message sent successfully: \(message)")
                    }
                }
            } catch {
                print("Error serializing message: \(error.localizedDescription)")
            }
        } else {
            print("WebSocket is not connected. Current state: \(webSocket.state). Attempting to reconnect.")
            messageQueue.append(message) // Add message to queue
            reconnectIfNeeded() // Attempt to reconnect
        }
    }
//    func sendMessage(_ message: [String: Any]) {
//        guard let webSocket = webSocket else {
//            print("WebSocket instance is nil.")
//            return
//        }
//
//        if webSocket.state == .running {
//            do {
//                let data = try JSONSerialization.data(withJSONObject: message, options: [])
//                let webSocketMessage = URLSessionWebSocketTask.Message.data(data)
//                webSocket.send(webSocketMessage) { error in
//                    if let error = error {
//                        print("Error sending message: \(error)")
//                        self.reconnectIfNeeded()
//                    } else {
//                        print("Message sent successfully: \(message)")
//                    }
//                }
//            } catch {
//                print("Error serializing message: \(error)")
//            }
//        } else {
//            print("WebSocket is not connected. Current state: \(webSocket.state). Attempting to reconnect.")
//            reconnectIfNeeded()
//        }
//    }
    
    
    
    func sendTextMessage(_ messageContent: String, senderId: Int, recipientId: Int, groupId: Int?) {
          let message: [String: Any] = [
              "type": "message",
              "sender_id": senderId,
              "recipient_id": recipientId,
              "group_id": groupId as Any,
              "message_content": messageContent,
              "media_type": "text",
              "created_at": getCurrentTimestamp()
          ]
          
          sendMessage(message)
      }
    
    private func getCurrentTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }
    
    func sendMediaMessage(mediaData: Data, senderId: Int, recipientId: Int, mediaType: String, mediaName: String, groupId: Int?, completion: @escaping (Result<String, Error>) -> Void) {
        var request = URLRequest(url: URL(string: "https://appnasif.com/appnasif_api/ws/upload_media")!)
        request.httpMethod = "POST"
        
        var body = Data()
        let boundary = "Boundary-\(UUID().uuidString)"
        
        let fileHeader = "--\(boundary)\r\n" +
        "Content-Disposition: form-data; name=\"file\"; filename=\"\(mediaName)\"\r\n" +
        "Content-Type: \(mediaType)\r\n\r\n"

        if let headerData = fileHeader.data(using: .utf8) {
            body.append(headerData)
        }
        
        body.append(mediaData)
        
        let endingBoundary = "\r\n--\(boundary)--\r\n"
        
        if let boundaryData = endingBoundary.data(using: .utf8) {
            body.append(boundaryData)
        }
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error uploading media: \(error)")
                completion(.failure(error))
                return
            }
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                if let mediaURL = String(data: data, encoding: .utf8) {
                    completion(.success(mediaURL))
                    
                    // Now send the uploaded media URL over WebSocket
                    self.sendTextMessage("Sent media: \(mediaURL)", senderId: senderId, recipientId: recipientId, groupId: groupId)
                } else {
                    completion(.failure(NSError(domain: "InvalidResponse", code: -1, userInfo: nil)))
                }
            }
        }
        
        task.resume()
    }
    
    func reconnectIfNeeded() {
        guard let webSocket = webSocket else { return }
        
        if webSocket.state == .suspended || webSocket.state == .canceling || webSocket.state == .completed {
            print("WebSocket is disconnected. Reconnecting...")
            connect()
            let retryDelay = 5.0 // Retry after 5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + retryDelay) {
                self.connect()  // Reconnect after a delay
            }
        }
    }


    func checkWebSocketState() {
        guard let webSocket = webSocket else { return }
        
        switch webSocket.state {
        case .running:
            print("WebSocket is running.")
        case .suspended:
            print("WebSocket is suspended.")
        case .canceling:
            print("WebSocket is canceling.")
        case .completed:
            print("WebSocket connection is completed (closed).")
        default:
            print("Unknown WebSocket state: \(webSocket.state)")
        }
    }

    func keepConnectionAlive() {
        guard let webSocket = webSocket, webSocket.state == .running else { return }
        // Sending a keep-alive message or ping could help maintain the connection.
        let keepAliveMessage = ["ping": "ping"]
        sendMessage(keepAliveMessage)  // Send a dummy message periodically
    }

    func closeConnection() {
        guard let webSocket = self.webSocket, webSocket.state == .completed else {
            print("WebSocket is already closed or not open.")
            return
        }
        webSocket.cancel(with: .goingAway, reason: nil)
        print("WebSocket connection closed.")
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("WebSocket is open and ready.")
        isConnected = true
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("WebSocket closed with code: \(closeCode.rawValue)")
        isConnected = false
        reconnectIfNeeded()
    }
}


