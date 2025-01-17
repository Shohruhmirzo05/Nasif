//
//  LanguageManager.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 09/01/25.
//

import SwiftUI

class LanguageManager: ObservableObject {
    @Published var localizedStrings: [String: String] = [:]
    @Published var currentLanguage: LanguageString = .en
    
    func fetchStrings(for language: LanguageString) {
        let mockResponse = """
        {
            "en": {
                "welcome_message": "Welcome to the App"
            },
            "ar": {
                "welcome_message": "مرحبًا بك في التطبيق"
            }
        }
        """
//        if let data = mockResponse.data(using: .utf8) {
//            let decoder = JSONDecoder()
//            if let localizedData = try? decoder.decode(LocalizedStrings.self, from: data) {
//                localizedStrings = currentLanguage == .en ? localizedData.ar : localizedData.en
//            }
//        }
    }
    
    func setLanguage(_ language: LanguageString) {
        currentLanguage = language
        updateLayoutDirection(language: language)
        fetchStrings(for: language)
    }
    
    private func updateLayoutDirection(language: LanguageString) {
        UIView.appearance().semanticContentAttribute =
        language == .ar ? .forceRightToLeft : .forceLeftToRight
    }
}

enum LanguageString: CaseIterable {
    case en, ar
    
    var language: String {
        switch self {
        case .en: return "en"
        case .ar: return "ar"
        }
    }
    //    switch self  {
    //    case .en: return "en"
    //    case .ar: return "ar"
    //    }
}

//import SwiftUI
//
//class LanguageManager: ObservableObject {
//    @Published var localizedStrings: [String: String] = [:]
//    @Published var currentLanguage: LanguageString = .en {
//        didSet {
//            fetchStrings(for: currentLanguage)
//            updateLayoutDirection(language: currentLanguage)
//        }
//    }
//    
//    init() {
//        // Initialize with the default language
//        fetchStrings(for: currentLanguage)
//    }
//
//    // Function to fetch localized strings based on the selected language
//    func fetchStrings(for language: LanguageString) {
//        let mockResponse = """
//        {
//            "en": {
//                "welcome_message": "Welcome to the App"
//            },
//            "ar": {
//                "welcome_message": "مرحبًا بك في التطبيق"
//            }
//        }
//        """
//        if let data = mockResponse.data(using: .utf8) {
//            let decoder = JSONDecoder()
//            if let localizedData = try? decoder.decode(LocalizedStrings.self, from: data) {
//                localizedStrings = language == .en ? localizedData.en : localizedData.ar
//            }
//        }
//    }
//
//    // Function to set the language
//    func setLanguage(_ language: LanguageString) {
//        currentLanguage = language
//    }
//    
//    // Function to update the layout direction based on the language
//    private func updateLayoutDirection(language: LanguageString) {
//        UIView.appearance().semanticContentAttribute =
//        language == .ar ? .forceRightToLeft : .forceLeftToRight
//    }
//}
//
//enum LanguageString: CaseIterable {
//    case en, ar
//    
//    var language: String {
//        switch self {
//        case .en: return "en"
//        case .ar: return "ar"
//        }
//    }
//}
//
//struct LocalizedStrings: Codable {
//    var en: [String: String]
//    var ar: [String: String]
//}
