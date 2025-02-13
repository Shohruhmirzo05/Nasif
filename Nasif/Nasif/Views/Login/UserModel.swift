//
//  UserModel.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 13/02/25.
//

import SwiftUI
import Combine

//{"status":"success",
//"message":"OTPverifiedsuccessfully",
//"data":{"token":"439343b286246d26f3ee502010eda2ceedb15b7e8c6b8fbe2b65059cefdfcc60",
//"phone":"+919524356849",
//"user_id":6}}

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

struct UserDefaultsKeys {
    static let accessToken = "accessToken"
    static let userId = "userId"
}

extension UserDefaults {
    var accessToken: String? {
        get { string(forKey: UserDefaultsKeys.accessToken) }
        set { set(newValue, forKey: UserDefaultsKeys.accessToken) }
    }

    var userId: Int? {
        get { integer(forKey: UserDefaultsKeys.userId) }
        set { set(newValue, forKey: UserDefaultsKeys.userId) }
    }
}

struct AuthResponse: Codable {
    let status, message: String
    let data: AuthResponseData?
}

struct AuthResponseData: Codable {
    let token: String?
    let phone: String?
    let userId: Int?
    
    enum CodingKeys: String, CodingKey {
        case token, phone
        case userId = "user_id"
    }
}

struct SignUpResponse: Codable {
    let message: String
}

struct RegistrationModel: Identifiable, Codable {
    var id: String
    var userPhoneNumber: String
    
    static let mock = RegistrationModel(id: UUID().uuidString, userPhoneNumber: "")
}
