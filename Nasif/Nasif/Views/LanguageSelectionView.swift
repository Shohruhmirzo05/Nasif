//
//  LanguageSelectionView.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 09/01/25.
//

import SwiftUI

struct LanguageSelectionView: View {
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(languageManager.currentLanguage == .en
                 ? "Welcome to the App"
                 : "مرحبًا بك في التطبيق")
            .padding()
        }
        
        Button{
            languageManager.setLanguage(.en)
        } label: {
            Text("Switch to English")
        }
        
        Button {
            languageManager.setLanguage(.ar)
        } label: {
            Text("Switch to Arabic")
        }
    }
}

#Preview {
    LanguageSelectionView()
        .environmentObject(LanguageManager())
}
