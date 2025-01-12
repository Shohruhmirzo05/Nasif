//
//  NasifApp.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 08/01/25.
//

import SwiftUI

@main
struct NasifApp: App {
    
    @StateObject private var languageManager = LanguageManager()
    
    var body: some Scene {
        WindowGroup {
            UserDetailsView()
                .environmentObject(languageManager)
        }
    }
}
