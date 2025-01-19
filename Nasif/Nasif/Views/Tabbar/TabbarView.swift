//
//  TabbarView.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 09/01/25.
//

import SwiftUI

struct TabbarView: View {
    @State private var selectedTab: TabItem = .listings
//    UIView.appearance().semanticContentAttribute =
//        language == .ar ? .forceRightToLeft : .forceLeftToRight

    
    var body: some View {
        TabView(selection: $selectedTab) {
            ProfileView()
                .tag(TabItem.profile)
                .tabItem {
                    Label(TabItem.profile.rawValue, systemImage: TabItem.profile.symbol)
                }
            DealsView()
                .tag(TabItem.deals)
                .tabItem {
                    Label(TabItem.deals.rawValue, systemImage: TabItem.deals.symbol)
                }
            MessagesView()
                .tag(TabItem.messages)
                .tabItem {
                    Label(TabItem.messages.rawValue, systemImage: TabItem.messages.symbol)
                }
            ListingsView()
                .tag(TabItem.listings)
                .tabItem {
                    Label(TabItem.listings.rawValue, systemImage: TabItem.listings.symbol)
                }
        }
        
        .background(.white)
    }
}

enum TabItem: LocalizedStringKey, CaseIterable {
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
}
