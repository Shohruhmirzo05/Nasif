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
            userId: Int,
            realEstateType: String,
            apartmnetName: String,
            apartmnetPrice: Int,
            apartmentTotalMetres: Int,
            apartmentAge: Int,
            streetWidth: Int,
            apartmentFacingSide: String,
            apartmentNumberOfStreets: Int,
            apartmentCity: String,
            apartmentNeightbourHood: String,
            apartmentLatitude: Double,
            apartmentLongitude: Double,
            apartmentMainImageUrl: String,
            apartmentAdditionaImages: [String],
            additionalVideoUrl: String,
            advertiserDescription: String,
            schemeNumber: String,
            aparmentPartNumber: String,
            valLicenceNumber: String?,
            advertisingLicenceNumber: String,
            description: String,
            availability: Int,
            villaType: String,
            intendedUse: String,
            floorNumber: Int,
            availableFloors: Int,
            bedroomCount: Int,
            bathroomCount: Int,
            livingRoomCount: Int,
            seatingAreaCount: Int,
            availableParking: Bool,
            services: [String],
            extraFeatures: [String]
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


