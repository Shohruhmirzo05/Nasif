//
//  APIClient.swift
//  ValidationComponents
//
//  Created by Shohruhmirzo Alijonov on 25/12/24.
//

import SwiftUI

class APIClient {
    
    static let shared = APIClient()
    
    private init() {}
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    enum Endpoint {
        case getListings
        case getlistingById(listingID: Int)
        
        case getAllMessages
        case getMessagesByGroupId(groupId: Int)
        case getMessagesById(messageId: Int)
        case getMessagesByUserId(userId: Int)
        
        case getUserByNickname(nickName: String)
        case getUserById(id: Int)
        
        case sendNumberForLogin(phoneNumber: String)
        case verifyOTP(phoneNumber: String, otpCode: String)
        case signUp(phoneNumber: String, nickName: String, profilePictureUrl: String)
        case getGroups
        case createGroup(name: String, adminId: Int)
        case sendMediaMessage(
            senderId: Int,
            recipientId: Int?,
            groupId: Int?,
            content: String,
            mediaType: String,
            mediaFile: Data,
            fileName: String
        )
        case sendListing(
            userId: Int? = nil,
            realEstateType: String? = nil,
            apartmnetName: String? = nil,
            apartmnetPrice: Int? = nil,
            apartmentTotalMetres: Int? = nil,
            apartmentAge: Int? = nil,
            streetWidth: Int? = nil,
            apartmentFacingSide: String? = nil,
            apartmentNumberOfStreets: Int? = nil,
            apartmentCity: String? = nil,
            apartmentNeightbourHood: String? = nil,
            apartmentLatitude: Double? = nil,
            apartmentLongitude: Double? = nil,
            apartmentMainImageUrl: String? = nil,   // ✅ Change to String?
            apartmentAdditionalImages: [String]? = nil,  // ✅ Fix spelling & change to [String]?
            additionalVideoUrl: String? = nil,  // ✅ Change to String?
            advertiserDescription: String? = nil,
            schemeNumber: String? = nil,
            aparmentPartNumber: String? = nil,
            valLicenceNumber: String? = nil,
            advertisingLicenceNumber: String? = nil,
            description: String? = nil,
            availability: Int? = nil,
            villaType: String? = nil,
            intendedUse: String? = nil,
            floorNumber: Int? = nil,
            availableFloors: Int? = nil,
            bedroomCount: Int? = nil,
            bathroomCount: Int? = nil,
            livingRoomCount: Int? = nil,
            seatingAreaCount: Int? = nil,
            availableParking: Bool? = nil,
            services: [String]? = nil,
            extraFeatures: [String]? = nil
        )

        
        fileprivate var url: URL {
            let baseURL = URL(string: AppEnvironment.current.baseUrl)!
            
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
            
            switch self {
            case .getListings:
                components.path.append("listings.php")
            case .getlistingById(let listingID):
                components.path.append("listings.php/\(listingID)")
            case .sendListing:
                components.path.append("listings.php")
                
                
            case .getAllMessages:
                components.path.append("message.php")
                
            case .getMessagesByGroupId(let groupId):
                components.path.append("message.php")
                
                components.queryItems = [
                    URLQueryItem(name: "group_id", value: "\(groupId)")
                ]
                
            case .getMessagesById(let messageId):
                components.path.append("message.php")
                components.queryItems = [
                    URLQueryItem(name: "message_id", value: "\(messageId)")
                ]
            case .getMessagesByUserId(let userId):
                components.path.append("message.php")
                components.queryItems = [
                    URLQueryItem(name: "user_id", value: "\(userId)")
                ]
            case .getGroups:
                components.path.append("groups.php")
            case .createGroup(let name, let adminId):
                components.path.append("groups.php")
            case .sendMediaMessage(let senderId, let recipientId, let groupId, let content, let mediaType, let mediaFile, let fileName):
                components.path.append("message.php")
                
                
            case .getUserByNickname(let nickName):
                components.path.append("user.php/\(nickName)")
            case .getUserById(let id):
                components.path.append("user.php/\(id)")
                
            case .sendNumberForLogin:
                components.path.append("auth/login.php")
            case .verifyOTP:
                components.path.append("auth/verify.php")
            case .signUp:
                components.path.append("auth/signup.php")
            }
            return components.url!
        }
        
        fileprivate var method: HTTPMethod {
            switch self {
            case .getListings, .getlistingById, .getAllMessages, .getMessagesByGroupId, .getMessagesById, .getMessagesByUserId, .getUserByNickname, .getUserById, .getGroups:
                return .get
            default:
                return .post
            }
        }
    }
    
    func getRequest(of endpoint: Endpoint) -> URLRequest {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = endpoint.method.rawValue
        let headers: [String: String] = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        var requestBody: [String: Any?] = [:]
        switch endpoint {
        case .sendNumberForLogin(let phoneNumber):
            requestBody = [
                "phone" : phoneNumber
            ]
        case .verifyOTP(let phoneNumber, let otpCode):
            requestBody = [
                "phone" : phoneNumber,
                "otp" : otpCode
            ]
        case .signUp(let phoneNumber, let nickName, let profilePictureUrl):
            requestBody = [
                "mobile_number" : phoneNumber,
                "nickname" : nickName,
                "profile_picture_url" : profilePictureUrl
            ]
        case .sendListing(let userId, let realEstateType, let apartmnetName, let apartmnetPrice, let apartmentTotalMetres, let apartmentAge, let streetWidth, let apartmentFacingSide, let apartmentNumberOfStreets, let apartmentCity, let apartmentNeightbourHood, let apartmentLatitude, let apartmentLongitude, let apartmentMainImageUrl, let apartmentAdditionaImages, let additionalVideoUrl, let advertiserDescription, let schemeNumber, let aparmentPartNumber, let valLicenceNumber, let advertisingLicenceNumber, let description, let availability, let villaType, let intendedUse, let floorNumber, let availableFloors, let bedroomCount, let bathroomCount, let livingRoomCount, let seatingAreaCount, let availableParking, let services, let extraFeatures): requestBody = [
            "user_id" : userId,
            "real_estate_type" : realEstateType,
            "title" : apartmnetName,
            "price" : apartmnetPrice,
            "total_square_meters" : apartmentTotalMetres,
            "real_estate_age" : apartmentAge,
            "street_width" : streetWidth,
            "facing" : apartmentFacingSide,
            "number_of_streets" : apartmentNumberOfStreets,
            "city" : apartmentCity,
            "neighborhood" : apartmentNeightbourHood,
            "latitude" : apartmentLatitude,
            "longitude" : apartmentLongitude,
            "main_image_url" : apartmentMainImageUrl,
            "additional_images_urls" : apartmentAdditionaImages,
            "additional_video_url" : additionalVideoUrl,
            "advertiser_description" : advertiserDescription,
            "scheme_number" : schemeNumber,
            "part_number" : aparmentPartNumber,
            "val_license_number" : valLicenceNumber,
            "advertising_license_number" : advertisingLicenceNumber,
            "description" : description,
            "availability" : availability,
            "villa_type" : villaType,
            "intended_use" : intendedUse,
            "floor_number" : floorNumber,
            "available_floors" : availableFloors,
            "bedroom_count" : bedroomCount,
            "bathroom_count" : bathroomCount,
            "living_room_count" : livingRoomCount,
            "seating_area_count" : seatingAreaCount,
            "available_parking" : availableParking,
            "services" : services,
            "extra_features" : extraFeatures
        ]
        default:
            break
        }
        if !requestBody.isEmpty {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: .fragmentsAllowed)
                request.httpBody = jsonData
                
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("Request JSON Body: \(jsonString)")
                }
            } catch {
                print("Failed to serialize request body to JSON: \(error)")
            }
        }
        request.allHTTPHeaderFields = headers
        return request
    }
    
    func sendMediaMessage(
        senderId: Int,
        recipientId: Int?,
        groupId: Int?,
        content: String,
        mediaType: String,
        mediaFile: Data,
        fileName: String
    ) async throws -> Message {
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: URL(string: "\(AppEnvironment.current.baseUrl)/message.php")!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var bodyData = Data()
        
        // Add text fields
        let textFields: [String: String] = [
            "sender_id": "\(senderId)",
            "recipient_id": recipientId.map { "\($0)" } ?? "",
            "group_id": groupId.map { "\($0)" } ?? "",
            "message_content": content,
            "media_type": mediaType
        ]
        
        for (key, value) in textFields {
            if !value.isEmpty {
                bodyData.append("--\(boundary)\r\n")
                bodyData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                bodyData.append("\(value)\r\n")
            }
        }
        
        bodyData.append("--\(boundary)\r\n")
        bodyData.append("Content-Disposition: form-data; name=\"media_file\"; filename=\"\(fileName)\"\r\n")
        bodyData.append("Content-Type: application/octet-stream\r\n\r\n")
        bodyData.append(mediaFile)
        bodyData.append("\r\n")
        
        bodyData.append("--\(boundary)--\r\n")
        request.httpBody = bodyData
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(Message.self, from: data)
    }
    
    func uploadMedia(
        image: UIImage?,
        videoURL: URL?,
        progressHandler: @escaping (Float) -> Void
    ) async throws -> (String?, String?) {  // No need for <T: Codable>
        
        let boundary = "Boundary-\(UUID().uuidString)"
//        var request = URLRequest(url: URL(string: "https://appnasif.com/appnasif_api/api/upload_media.php")!)
        var request = URLRequest(url: URL(string: "https://appnasif.com/appnasif_api/api/listings.php")!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Upload Image
        var uploadedImageUrl: String? = nil
        if let image = image, let imageData = image.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // Upload Video
        var uploadedVideoUrl: String? = nil
        if let videoURL = videoURL {
            do {
                let videoData = try Data(contentsOf: videoURL)
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"video\"; filename=\"video.mp4\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: video/mp4\r\n\r\n".data(using: .utf8)!)
                body.append(videoData)
                body.append("\r\n".data(using: .utf8)!)
            } catch {
                print("Failed to load video data: \(error)")
                throw error
            }
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        request.setValue("\(body.count)", forHTTPHeaderField: "Content-Length") // Set Content-Length
        
        let (data, response) = try await upload(request: request, from: body, progressHandler: progressHandler)

        // 🔴 Print Raw Response Before Decoding
        if let responseString = String(data: data, encoding: .utf8) {
            print("🔴 Raw Response from Upload API: \(responseString)")
        }

        do {
            let parsedResponse = try JSONDecoder().decode([String: String].self, from: data)
            uploadedImageUrl = parsedResponse["image_url"]
            uploadedVideoUrl = parsedResponse["video_url"]
        } catch {
            print("❌ Failed to decode response: \(error)")
            throw error
        }
        
        return (uploadedImageUrl, uploadedVideoUrl)
    }

        
        private func upload(
            request: URLRequest,
            from bodyData: Data,
            progressHandler: @escaping (Float) -> Void
        ) async throws -> (Data, URLResponse) {
            var mutableRequest = request
            mutableRequest.httpBody = nil
            
            let sessionConfiguration = URLSessionConfiguration.default
            let sessionDelegate = UploadTaskDelegate(progressHandler: progressHandler)
            let session = URLSession(configuration: sessionConfiguration, delegate: sessionDelegate, delegateQueue: nil)
            
            return try await withCheckedThrowingContinuation { continuation in
                let uploadTask = session.uploadTask(with: mutableRequest, from: bodyData) { data, response, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let data = data, let response = response {
                        continuation.resume(returning: (data, response))
                    } else {
                        continuation.resume(throwing: URLError(.badServerResponse))
                    }
                }
                uploadTask.resume()
            }
        }
    

}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

extension APIClient {
    
    func callWithStatusCode<T: Codable>(_ endpoint: Endpoint, decodeTo: T.Type) async throws -> (data: T, statusCode: Int) {
        let request = getRequest(of: endpoint)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "InvalidResponse", code: -1, userInfo: nil)
        }
        let statusCode = httpResponse.statusCode
        print("\nRequest: \(request.cURL())")
        if let jsonString = data.prettyPrintedJSONString {
            print(jsonString)
        }
        let parsedData = try JSONDecoder().decode(T.self, from: data)
        return (data: parsedData, statusCode: statusCode)
    }
    
    func call<T: Codable>(_ endpoint: Endpoint, decodeTo: T.Type) async throws -> T {
        let request = getRequest(of: endpoint)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "InvalidResponse", code: -1, userInfo: nil)
        }
        let /*statusCode*/_ = httpResponse.statusCode
        print("\nRequest: \(request.cURL())")
        if let jsonString = data.prettyPrintedJSONString {
            print(jsonString)
        }
        let parsedData = try JSONDecoder().decode(T.self, from: data)
        return parsedData
    }
    
}


class UploadTaskDelegate: NSObject, URLSessionTaskDelegate {
    let progressHandler: (Float) -> Void
    
    init(progressHandler: @escaping (Float) -> Void) {
        self.progressHandler = progressHandler
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let progress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        progressHandler(progress)
    }
}


//extension APIClient {
//    func uploadMediaFiles(
//        mainImage: UIImage?,
//        additionalImages: [UIImage],
//        videoURL: URL?
//    ) async throws -> (mainImageUrl: String?, additionalImageUrls: [String], videoUrl: String?) {
//        let boundary = "Boundary-\(UUID().uuidString)"
//        var request = URLRequest(url: URL(string: "\(AppEnvironment.current.baseUrl)/upload_media.php")!)
//        request.httpMethod = "POST"
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        
//        var body = Data()
//        
//        // Convert and append main image
//        if let mainImage = mainImage, let imageData = mainImage.jpegData(compressionQuality: 0.8) {
//            body.append("--\(boundary)\r\n")
//            body.append("Content-Disposition: form-data; name=\"main_image\"; filename=\"main_image.jpg\"\r\n")
//            body.append("Content-Type: image/jpeg\r\n\r\n")
//            body.append(imageData)
//            body.append("\r\n")
//        }
//        
//        // Convert and append additional images
//        for (index, image) in additionalImages.enumerated() {
//            if let imageData = image.jpegData(compressionQuality: 0.8) {
//                body.append("--\(boundary)\r\n")
//                body.append("Content-Disposition: form-data; name=\"additional_images[]\"; filename=\"image\(index).jpg\"\r\n")
//                body.append("Content-Type: image/jpeg\r\n\r\n")
//                body.append(imageData)
//                body.append("\r\n")
//            }
//        }
//        
//        // Append video data
//        if let videoURL = videoURL {
//            do {
//                let videoData = try Data(contentsOf: videoURL)
//                body.append("--\(boundary)\r\n")
//                body.append("Content-Disposition: form-data; name=\"video\"; filename=\"video.mp4\"\r\n")
//                body.append("Content-Type: video/mp4\r\n\r\n")
//                body.append(videoData)
//                body.append("\r\n")
//            } catch {
//                throw error
//            }
//        }
//        
//        body.append("--\(boundary)--\r\n")
//        request.httpBody = body
//        
//        let (data, _) = try await URLSession.shared.data(for: request)
//        
//        // Print raw response for debugging
//        if let responseString = String(data: data, encoding: .utf8) {
//            print("Raw Upload Response: \(responseString)")
//        }
//        
//        struct UploadResponse: Codable {
//            let main_image_url: String?
//            let additional_images_urls: [String]?
//            let video_url: String?
//        }
//        
//        let response = try JSONDecoder().decode(UploadResponse.self, from: data)
//        return (response.main_image_url, response.additional_images_urls ?? [], response.video_url)
//    }
//}

extension APIClient {
    func uploadMediaFiles(
        mainImage: UIImage?,
        additionalImages: [UIImage],
        videoURL: URL?
    ) async throws -> (mainImageUrl: String?, additionalImageUrls: [String], videoUrl: String?) {
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: URL(string: "\(AppEnvironment.current.baseUrl)/listings.php")!)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        // Helper function to append form data
        func append(_ string: String) {
            if let data = string.data(using: .utf8) {
                body.append(data)
            }
        }

        // Add main image
        if let mainImage = mainImage, let imageData = mainImage.jpegData(compressionQuality: 0.8) {
            append("--\(boundary)\r\n")
            append("Content-Disposition: form-data; name=\"main_image\"; filename=\"main.jpg\"\r\n")
            append("Content-Type: image/jpeg\r\n\r\n")
            body.append(imageData)
            append("\r\n")
        }

        // Add additional images
        for (index, image) in additionalImages.enumerated() {
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                append("--\(boundary)\r\n")
                append("Content-Disposition: form-data; name=\"additional_images[\(index)]\"; filename=\"additional\(index).jpg\"\r\n")
                append("Content-Type: image/jpeg\r\n\r\n")
                body.append(imageData)
                append("\r\n")
            }
        }

        // Add video
        if let videoURL = videoURL {
            let videoData = try Data(contentsOf: videoURL)
            append("--\(boundary)\r\n")
            append("Content-Disposition: form-data; name=\"video\"; filename=\"video.mp4\"\r\n")
            append("Content-Type: video/mp4\r\n\r\n")
            body.append(videoData)
            append("\r\n")
        }

        append("--\(boundary)--\r\n")
        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            let errorResponse = String(data: data, encoding: .utf8) ?? "No data"
            print("Failed to upload media. Server responded with: \(errorResponse)")
            throw NSError(domain: "UploadError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to upload media. Server responded with: \(errorResponse)"])
        }

        struct UploadResponse: Codable {
            let main_image_url: String?
            let additional_images_urls: [String]?
            let video_url: String?
        }

        let decoder = JSONDecoder()
        let uploadResponse = try decoder.decode(UploadResponse.self, from: data)
        return (uploadResponse.main_image_url, uploadResponse.additional_images_urls ?? [], uploadResponse.video_url)
    }
}
