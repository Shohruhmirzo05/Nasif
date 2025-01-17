//
//  ProfileView.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 09/01/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        VStack {
            Button(action: {
                let newLanguage: LanguageString = languageManager.currentLanguage == .en ? .ar : .en
                languageManager.setLanguage(newLanguage)
                // Refresh the interface after changing the language
            }) {
                Text(languageManager.currentLanguage == .en ? "Switch to Arabic" : "Switch to English")
            }

//            Text(languageManager.localizedStrings["welcome_message"] ?? "Welcome to the App")
//                .font(.title)
//                .padding()
//            
//            Button(action: {
//                languageManager.setLanguage(.en)
//            }) {
//                Text("Switch to English")
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            
//            Button(action: {
//                languageManager.setLanguage(.ar)
//            }) {
//                Text("تغيير إلى العربية")
//                    .padding()
//                    .background(Color.green)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
        }
        .padding()
    }
}

