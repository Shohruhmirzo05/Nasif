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
    @EnvironmentObject var profileViewModel: ProfileViewModel

    var body: some View {
        Group {
            if let userId = UserDefaults.standard.userId, userId > 0 {
                TabbarView()
            } else {
                PhoneInputView(viewModel: authVM)
            }
        }
        .environment(\.layoutDirection, profileViewModel.layoutDirection ?? LayoutDirection.leftToRight) // Set layout direction
        .animation(.interpolatingSpring, value: authVM.isAuthenticated)
    }
}

#Preview {
    ContentView()
}
