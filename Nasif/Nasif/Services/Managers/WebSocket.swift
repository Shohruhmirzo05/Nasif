//
//  WebSocket.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 07/02/25.
//

import Foundation
import SwiftUI

//class WebSocketClient {
//    static let shared = WebSocketClient()
//    private var webSocketTask: URLSessionWebSocketTask?
//    private let urlSession = URLSession(configuration: .default)
//    
//    private init() {}
//    
//    // Connect to the WebSocket
//    func connect() {
//        let url = URL(string: "wss://appnasif.com:8081/ws")!
//        webSocketTask = urlSession.webSocketTask(with: url)
//        webSocketTask?.resume()
//        
//        // Listen for incoming messages
//        receiveMessages()
//    }
//    
//    // Send a text message to the WebSocket server
//    func sendTextMessage(_ message: String) {
//        let message = URLSessionWebSocketTask.Message.string(message)
//        webSocketTask?.send(message) { error in
//            if let error = error {
//                print("Error sending message: \(error)")
//            }
//        }
//    }
//    
//    // Send media (image/video) to the WebSocket server as form-data
//    func sendMediaMessage(_ mediaData: Data, senderId: Int, recipientId: Int, mediaType: String, mediaName: String) {
//        var request = URLRequest(url: URL(string: "https://appnasif.com/appnasif_api/ws/upload_media")!)
//        request.httpMethod = "POST"
//        
//        // Create multipart form-data for media upload
//        var body = Data()
//        let boundary = "Boundary-\(UUID().uuidString)"
//        
//        // Add media content to form-data
//        let fileHeader = "--\(boundary)\r\n" +
//                         "Content-Disposition: form-data; name=\"file\"; filename=\"\(mediaName)\"\r\n" +
//                         "Content-Type: \(mediaType)\r\n\r\n"
//        
//        // Convert file header to Data and append
//        if let headerData = fileHeader.data(using: .utf8) {
//            body.append(headerData)
//        }
//        
//        // Append the media data
//        body.append(mediaData)
//        
//        // Add ending boundary
//        let endingBoundary = "\r\n--\(boundary)--\r\n"
//        
//        // Convert ending boundary to Data and append
//        if let boundaryData = endingBoundary.data(using: .utf8) {
//            body.append(boundaryData)
//        }
//        
//        // Set content type to multipart form-data
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        request.httpBody = body
//        
//        // Send the media via an HTTP request (the backend will return a URL or file ID)
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error uploading media: \(error)")
//                return
//            }
//            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
//                // Handle successful media upload (response contains URL or file ID)
//                // Send the media URL or file ID over WebSocket
//                let mediaURL = String(data: data, encoding: .utf8) ?? "Unknown URL"
//                let message = "Sent media to \(recipientId): \(mediaURL)"
//                self.sendTextMessage(message)
//            }
//        }
//        
//        task.resume()
//    }
//
//    
//    // Receive messages from the WebSocket server
//    private func receiveMessages() {
//        webSocketTask?.receive { [weak self] result in
//            switch result {
//            case .success(let message):
//                switch message {
//                case .string(let text):
//                    print("Received message: \(text)")
//                    // Process the incoming text message and update the UI
//                case .data(let data):
//                    print("Received data: \(data)")
//                    // Process media data if needed
//                @unknown default:
//                    break
//                }
//                self?.receiveMessages() // Continue listening for new messages
//            case .failure(let error):
//                print("Error receiving message: \(error)")
//            }
//        }
//    }
//    
//    // Disconnect from WebSocket
//    func disconnect() {
//        webSocketTask?.cancel(with: .goingAway, reason: nil)
//    }
//}
class WebSocketManager {
    static let shared = WebSocketManager()
    var webSocket: URLSessionWebSocketTask?
    
    private init() {}
    
    func connect() {
        let url = URL(string: "wss://appnasif.com:8081/ws")!
        let session = URLSession(configuration: .default)
        webSocket = session.webSocketTask(with: url)
        webSocket?.resume()
    }
    
    func sendMessage(_ message: [String: Any]) {
        do {
            let data = try JSONSerialization.data(withJSONObject: message, options: [])
            let message = URLSessionWebSocketTask.Message.data(data)
            webSocket?.send(message) { error in
                if let error = error {
                    print("Error sending message: \(error)")
                }
            }
        } catch {
            print("Error serializing message: \(error)")
        }
    }
    
    // This is the new method to handle media upload
    func sendMediaMessage(mediaData: Data, senderId: Int, recipientId: Int, mediaType: String, mediaName: String, completion: @escaping (Result<String, Error>) -> Void) {
        var request = URLRequest(url: URL(string: "https://appnasif.com/appnasif_api/ws/upload_media")!)
        request.httpMethod = "POST"
        
        var body = Data()
        let boundary = "Boundary-\(UUID().uuidString)"
        
        // Add media content to form-data
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
        
        // Perform media upload request
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
                    self.sendTextMessage("Sent media: \(mediaURL)", toRecipientId: recipientId)
                } else {
                    completion(.failure(NSError(domain: "InvalidResponse", code: -1, userInfo: nil)))
                }
            }
        }
        
        task.resume()
    }
    
    // This method sends the text message along with media URLs (or text)
    func sendTextMessage(_ message: String, toRecipientId recipientId: Int) {
        let messageDict: [String: Any] = [
            "sender_id": 1,  // Example sender ID (use actual sender ID)
            "recipient_id": recipientId,
            "message_content": message,
            "media_type": "text",  // Change media type as needed (e.g. "image", "video", etc.)
            "created_at": Date().description
        ]
        
        // Send message over WebSocket
        self.sendMessage(messageDict)
    }
}
