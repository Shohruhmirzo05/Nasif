//
//  WebSocket.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 07/02/25.
//

import SwiftUI

class WebSocketManager {
    static let shared = WebSocketManager()
    var webSocket: URLSessionWebSocketTask?
    var onMessageReceived: ((Message) -> Void)?
    
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
            print("WebSocket instance is nil.")
            return
        }

        if webSocket.state == .running {
            do {
                let data = try JSONSerialization.data(withJSONObject: message, options: [])
                let webSocketMessage = URLSessionWebSocketTask.Message.data(data)
                webSocket.send(webSocketMessage) { error in
                    if let error = error {
                        print("Error sending message: \(error)")
                        self.reconnectIfNeeded()
                    }
                }
            } catch {
                print("Error serializing message: \(error)")
            }
        } else {
            print("WebSocket is not connected, attempting to reconnect.")
            reconnectIfNeeded()
        }
    }
    
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
//    func sendTextMessage(_ messageContent: String, senderId: Int, recipientId: Int, groupId: Int?) {
//          let messageDict: [String: Any] = [
//              "sender_id": senderId,
//              "recipient_id": recipientId,
//              "message_content": messageContent,
//              "media_type": "text",
//              "group_id": groupId ?? NSNull(), // Include group ID if available
//              "created_at": getCurrentTimestamp()
//          ]
//          
//          sendMessage(messageDict)
//      }
    
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
}

