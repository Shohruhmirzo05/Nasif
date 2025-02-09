//
//  ContentView.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 08/01/25.
//

import SwiftUI

enum ContentScreens: Int {
    case onboarding
    case main
}

struct ContentView: View {
    @StateObject private var authVM = AuthViewModel()
    @AppStorage(AppStorageKeys.currentContent) var currentContent = ContentScreens.onboarding
    
    let userId: Int? = {
        return UserDefaults.standard.integer(forKey: "userId")
    }()
    
    var body: some View {
        Group {
//            if currentContent == .onboarding {
//                if authVM.isAuthenticated {
//                    TabbarView()
//                } else {
//                    PhoneInputView(viewModel: authVM)
//                }
//            } else {
                TabbarView()
//            }
        }
        .animation(.interpolatingSpring, value: authVM.isAuthenticated)
    }
}


#Preview {
    ContentView()
//        .environmentObject(LanguageManager())
}
