//
//  URLRequest+.swift
//  ValidationComponents
//
//  Created by Shohruhmirzo Alijonov on 26/12/24.
//

import Foundation

extension URLRequest {
    func cURL() -> String {
        var curl = "curl --location"
        // Add location and HTTP method
        if let location = self.url?.absoluteString {
            curl += " --request \(self.httpMethod?.uppercased() ?? "GET") '\(location)'"
        }
        // Add headers
        if let headers = self.allHTTPHeaderFields {
            for (key, value) in headers {
                curl += " \\\n--header '\(key): \(value)'"
            }
        }
        // Add body if present
        if let httpBody = self.httpBody, let bodyString = String(data: httpBody, encoding: .utf8), !bodyString.isEmpty {
            curl += " \\\n--data '\(bodyString)'"
        }
        return curl
    }
}
