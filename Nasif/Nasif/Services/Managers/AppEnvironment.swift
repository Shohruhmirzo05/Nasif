//
//  AppEnvironment.swift
//  ValidationComponents
//
//  Created by Shohruhmirzo Alijonov on 26/12/24.
//

import Foundation

enum AppEnvironment: String {
    case development
    case production
}

extension AppEnvironment {
    static var current: AppEnvironment {
#if RELEASE
        return .production
#elseif DEBUG
        return .development
#else
        return .development
#endif
    }
}

extension AppEnvironment {
    private var keyPairs: [String: String] {
        guard
            let infoDictionary = Bundle.main.infoDictionary,
            let envDictionary = infoDictionary["Environments"] as? [String: [String: String]],
            let keyPairs = envDictionary[self.rawValue]
        else {
            fatalError("Missing or invalid configuration for \(self.rawValue) environment in Info.plist.")
        }
        return keyPairs
    }

    var baseUrl: String {
        keyPairs["baseUrl"] ?? ""
    }
}
