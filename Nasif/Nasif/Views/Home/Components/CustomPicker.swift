//
//  CustomPicker.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 09/01/25.
//

import SwiftUI

struct CustomTabPickerView: View {
    @State private var width: CGFloat = 20
    @Namespace var namespace
    
    @Binding var selectedTab: String
    
    let tabs: [ String ]
    
    var body: some View {
        VStack {
            TabsView()
        }
    }
    
    @ViewBuilder func TabsView() -> some View {
        HStack(spacing: 10) {
            ForEach(tabs, id: \.self) { tab in
                TabItemView(tab: tab)
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.3), value: selectedTab)
        .padding(.vertical, 6)
        .background {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.gray.opacity(0.2))
                .ignoresSafeArea(edges: .bottom)
        }
    }
    
    @ViewBuilder func TabItemView(tab: String) -> some View {
        Text(tab)
            .font(.abel(size: 14))
            .foregroundColor(selectedTab == tab ? .black : .gray)
            .padding(.vertical, 6)
            .frame(maxWidth: 32, maxHeight: 32)
            .padding(.horizontal, 8)
            .background {
                if selectedTab == tab {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .matchedGeometryEffect(id: "tab_background", in: namespace)
                        .shadow( color: .gray.opacity(0.5), radius: 4)
                } else {
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.white.opacity(0.001))
                }
            }
            .onTapGesture {
                withAnimation {
                    selectedTab = tab
                    
                }
            }
    }
}

#Preview {
    CustomTabPickerView( selectedTab: .constant("All"), tabs: ["All", "Land", "Villa", "Apart.", "Floor", "Build.", "Other"]
)
}
