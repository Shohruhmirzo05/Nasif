//
//  View+.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 09/01/25.
//

import SwiftUI

extension View {
    func apply<V: View>(@ViewBuilder _ block: (Self) -> V) -> V {
        block(self)
    }
    
    func defaultShadow(isNeumorphism: Bool = true) -> some View {
        self.shadow(color: Color.black.opacity(0.1), radius: 8, y: 8)
            .shadow(color: Color(UIColor.systemBackground).opacity(isNeumorphism ? 1 : 0), radius: 8,  x: -4, y: -6)
    }
}
