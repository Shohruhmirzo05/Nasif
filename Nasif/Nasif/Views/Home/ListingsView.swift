//
//  ListingsView.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 09/01/25.
//

import SwiftUI

struct ListingsView: View {
    
    let tabs = ["All", "Land", "Villa", "Apart.", "Floor", "Build.", "Other"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    
                }
            }
            .safeAreaInset(edge: .top) {
                CustomTabPickerView(tabs: tabs)
                    .padding(.horizontal, 4)
                    .padding(.vertical)
                    .background(.white)
            }
        }
    }
}

#Preview {
    ListingsView()
}
