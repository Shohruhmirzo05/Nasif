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
        
        fileprivate var url: URL {
            let baseURL = URL(string: AppEnvironment.current.baseUrl)!
            
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
            
            switch self {
            case .getListings:
                components.path.append("listings.php")
            case .getlistingById(let listingID):
                components.path.append("listings.php/\(listingID)")
            }
            
            return components.url!
        }
        
        fileprivate var method: HTTPMethod {
            switch self {
            case .getListings, .getlistingById:
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
        default:
            break
        }
        if !requestBody.isEmpty {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: .fragmentsAllowed)
                request.httpBody = jsonData
                
                // Debugging: Print JSON body as a string
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


