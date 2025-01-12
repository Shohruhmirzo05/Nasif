//
//  Color+.swift
//  Feliza
//
//  Created by Shohruhmirzo Alijonov on 06/01/25.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hexSanitized = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hexSanitized)
        var hexInt: UInt64 = 0
        scanner.scanHexInt64(&hexInt)
        
        let r = CGFloat((hexInt & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hexInt & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(hexInt & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}

