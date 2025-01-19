//
//  Constants.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 17/01/25.
//

import SwiftUI

extension String {
    func localizedFormat(identifier: String? = nil, table: String? = "Localizable", components: CVarArg...) -> String {
        String(format: self.localizedString(identifier: identifier, table: table), components)
    }
    
    func localizedString(identifier: String? = nil, table: String? = "Localizable") -> String {
        let currentIdentifier = UserDefaults.standard.string(forKey: AppStorageKeys.appLanguage) ?? Constants.defaultLanguage
        let currentLocale = Locale(identifier: identifier ?? currentIdentifier)
        if #available(iOS 16, *) {
            guard let languageCode = currentLocale.language.languageCode?.identifier,
                  let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
                  let bundle = Bundle(path: path) else {
                return self
                
            }
            return NSLocalizedString(self, tableName: table, bundle: bundle, comment: "")
        } else {
           
        }
       
    }
}

class Constants {
    
    static let defaultLanguage = "uz"
    static let defaultCurrency = "UZS"
    static let countryCode = "+998"
    static let contactUsUrl = "https://t.me/zbekz_support"
    static let instagramUrl = "https://www.instagram.com/karly.app"
    static let telegramUrl = "https://t.me/karlyappuz"
    static var didRunRandomAction = false
    
    static let languages: [Language] = [
        Language(name: "🇸🇦 Arabic", identifier: "ar"),
        Language(name: "🇬🇧 Enlish", identifier: "en"),
    ]
    
    static let supportedCurrencies: [String] = ["UZS", "USD"]

}

struct Language: Identifiable {
    let id = UUID()
    let name: String
    let identifier: String
}
