//
//  ContentView.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 08/01/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var languageManager: LanguageManager

    var body: some View {
        VStack {
            Text(languageManager.localizedStrings["welcome_message"] ?? "Loading...")
                .padding()
            
            LanguageSelectionView()
        }
        .onAppear {
            languageManager.fetchStrings(for: languageManager.currentLanguage)
        }
        .frame(maxWidth: .infinity, alignment: languageManager.currentLanguage == .en ? .leading : .trailing)
    }
}


#Preview {
    ContentView()
        .environmentObject(LanguageManager())
}
