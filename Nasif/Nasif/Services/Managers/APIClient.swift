////
////  APIClient.swift
////  ValidationComponents
////
////  Created by Shohruhmirzo Alijonov on 25/12/24.
////
//
//import SwiftUI
//
//class APIClient {
//    
//    static let shared = APIClient()
//    
//    private init() {}
//    
//    enum HTTPMethod: String {
//        case get = "GET"
//        case post = "POST"
//        case patch = "PATCH"
//        case put = "PUT"
//        case delete = "DELETE"
//    }
//    
//    enum Endpoint {
//        
//        // mock
//        // need to refactor to link it to api properly
//        case getAllApps(search: String, category: String, isWeb: String, isMobile: String, limit: Int, offset: Int)
//        case getLastUsedApps(limit: Int, offset: Int)
//        case postLogin(requestID: String, deviceID: String, deviceDisplayName: String, macAddress: String, deviceType: String)
//        
//        case searchProducts(query: String)
//        case getAllSaleGroups
//        
//        fileprivate var url: URL {
//            var baseURL = URL(string: AppEnvironment.current.baseUrl)!
//            switch self {
//                // mock
//            case .getAllApps:
////                baseURL = baseURL.appending(path: "application").appending(path: "all")
//            case .getLastUsedApps:
//                baseURL = baseURL.appending(path: "application").appending(path: "last-used")
//            case .postLogin:
//                baseURL = baseURL.appendingPathComponent("auth").appending(path: "login")
//                
//                
//            case .searchProducts(let query):
//                baseURL = baseURL.appending(path: "product").appending(path: "searchProduct")
//            case .getAllSaleGroups:
//                baseURL = baseURL.appending(path: "sale-group").appending(path: "all")
//            }
//            return baseURL
//        }
//        
//        fileprivate var method: HTTPMethod {
//            switch self {
//            case .getAllApps, .getLastUsedApps, .getAllSaleGroups:
//                return .get
//            default:
//                return .post
//            }
//        }
//    }
//    
//    func getRequest(of endpoint: Endpoint) -> URLRequest {
//        var request = URLRequest(url: endpoint.url)
//        request.httpMethod = endpoint.method.rawValue
//        let headers: [String: String] = [
//            "Accept": "application/json",
//            "Content-Type": "application/json"
//        ]
//        var requestBody: [String: Any?] = [:]
//        switch endpoint {
//        case .getAllApps(let search, let category, let isWeb, let isMobile, let limit, let offset):
//            requestBody = [
//                "search" : search,
//                "category" : category,
//                "is_web" : isWeb,
//                "is_mobile" : isMobile,
//                "limit" : limit,
//                "offset" : offset
//            ]
//        case .getLastUsedApps(let limit, let offset):
//            requestBody = [
//                "limit" : limit,
//                "offset" : offset
//            ]
//        case .postLogin(let requestID, let deviceID, let deviceDisplayName, let macAddress, let deviceType):
//            requestBody = [
//                "request_id" : requestID,
//                "device_id" : deviceID,
//                "device_display_name" : deviceDisplayName,
//                "mac_address" : macAddress,
//                "device_type" : deviceType
//            ]
//        default:
//            break
//        }
//        request.allHTTPHeaderFields = headers
//        if !requestBody.isEmpty {
//            request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: .fragmentsAllowed)
//        }
//        return request
//    }
//}
//
//extension APIClient {
//    
//    func callWithStatusCode<T: Codable>(_ endpoint: Endpoint, decodeTo: T.Type) async throws -> (data: T, statusCode: Int) {
//        let request = getRequest(of: endpoint)
//        let (data, response) = try await URLSession.shared.data(for: request)
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw NSError(domain: "InvalidResponse", code: -1, userInfo: nil)
//        }
//        let statusCode = httpResponse.statusCode
//        print("\nRequest: \(request.cURL())")
//        if let jsonString = data.prettyPrintedJSONString {
//            print(jsonString)
//        }
//        let parsedData = try JSONDecoder().decode(T.self, from: data)
//        return (data: parsedData, statusCode: statusCode)
//    }
//    
//    func call<T: Codable>(_ endpoint: Endpoint, decodeTo: T.Type) async throws -> T {
//        let request = getRequest(of: endpoint)
//        let (data, response) = try await URLSession.shared.data(for: request)
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw NSError(domain: "InvalidResponse", code: -1, userInfo: nil)
//        }
//        let /*statusCode*/_ = httpResponse.statusCode
//        print("\nRequest: \(request.cURL())")
//        if let jsonString = data.prettyPrintedJSONString {
//            print(jsonString)
//        }
//        let parsedData = try JSONDecoder().decode(T.self, from: data)
//        return parsedData
//    }
//}
