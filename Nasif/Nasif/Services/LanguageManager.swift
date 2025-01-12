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
        if let data = mockResponse.data(using: .utf8) {
            let decoder = JSONDecoder()
            if let localizedData = try? decoder.decode(LocalizedStrings.self, from: data) {
                localizedStrings = currentLanguage == .en ? localizedData.ar : localizedData.en
            }
        }
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

