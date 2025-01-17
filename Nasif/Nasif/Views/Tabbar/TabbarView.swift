//
//  TabbarView.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 09/01/25.
//

import SwiftUI

struct TabbarView: View {
    @State private var selectedTab: TabItem = .listings
    @StateObject private var languageManager = LanguageManager()
//    UIView.appearance().semanticContentAttribute =
//        language == .ar ? .forceRightToLeft : .forceLeftToRight

    
    var body: some View {
        TabView(selection: $selectedTab) {
            ProfileView()
                .tag(TabItem.profile)
                .tabItem {
                    Label(
                        NSLocalizedString("\(TabItem.profile.name)", comment: ""),
                        systemImage: TabItem.profile.symbol
                    )
                }
            DealsView()
                .tag(TabItem.deals)
                .tabItem {
                    Label(
                        NSLocalizedString("\(TabItem.deals.name)", comment: ""),
                        systemImage: TabItem.deals.symbol
                    )
                }
            MessagesView()
                .tag(TabItem.messages)
                .tabItem {
                    Label(
                        NSLocalizedString("\(TabItem.messages.name)", comment: ""),
                        systemImage: TabItem.messages.symbol
                    )
                }
            ListingsView()
                .tag(TabItem.listings)
                .tabItem {
                  
                    Label(
                        NSLocalizedString("\(TabItem.listings.name)", comment: ""),
                        systemImage: TabItem.listings.symbol
                    )
                }
        }
        .environmentObject(languageManager)
        
        .background(.white)
    }
}

enum TabItem: String, CaseIterable {
    case profile
    case deals
    case messages
    case listings
    
    var name: LocalizedStringKey {
        switch self {
        case .profile: return "Profile"
        case .deals: return "Deals"
        case .messages: return "Messages"
        case .listings: return "Listings"
        }
    }
    var symbol: String {
        switch self {
        case .profile: return "person.fill"
        case .deals: return "shippingbox.fill"
        case .messages: return "briefcase"
        case .listings: return "shippingbox.fill"
        }
    }
}

#Preview {
    TabbarView()
        .environmentObject(LanguageManager())
}

//                    Label(TabItem.profile.rawValue, systemImage: TabItem.profile.symbol)
//                    Label(
//                        languageManager.localizedStrings[TabItem.profile.rawValue] ?? TabItem.profile.rawValue,
//                        systemImage: TabItem.profile.symbol
//                    )

//                    Label(TabItem.deals.rawValue, systemImage: TabItem.deals.symbol)
//                    Label(
//                        languageManager.localizedStrings[TabItem.deals.rawValue] ?? TabItem.deals.rawValue,
//                        systemImage: TabItem.deals.symbol
//                    )

//                    Label(TabItem.listings.rawValue, systemImage: TabItem.listings.symbol)
//                    Label(
//                        languageManager.localizedStrings[TabItem.listings.rawValue] ?? TabItem.listings.rawValue,
//                        systemImage: TabItem.listings.symbol
//                    )
