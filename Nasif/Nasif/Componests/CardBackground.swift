//
//  CardBackground.swift
//  ValidationComponents
//
//  Created by Shohruhmirzo Alijonov on 12/12/24.
//

import SwiftUI

/// By default values: isShadowOn: true, padding: 16, cornerRadius: 8
struct CardBackground<Content: View>: View {
    
    let content: Content
    let isShadowOn: Bool
    let cornerRadius: CGFloat
    let backgroundColor: Color
    let verticalPadding: CGFloat
    let horizontalPadding: CGFloat
    let maxWidthOn: Bool

    init(isShadowOn: Bool = true, cornerRadius: CGFloat = 10, backgroundColor: Color = .white,
         verticalPadding:  CGFloat = 12, horizontalPadding: CGFloat = 16, maxWidthOn: Bool = true, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content()
        self.isShadowOn = isShadowOn
        self.backgroundColor = backgroundColor
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
        self.maxWidthOn = maxWidthOn
    }
    
    var body: some View {
        if isShadowOn {
            ContentWithoutShadow()
                .defaultShadow()
        } else {
            ContentWithoutShadow()
        }
    }
    
    @ViewBuilder func ContentWithoutShadow() -> some View {
        content
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horizontalPadding)
            .frame(maxWidth: maxWidthOn ? .infinity : nil, alignment: .leading)
            .background(backgroundColor)
            .clipShape(.rect(cornerRadius: cornerRadius))
    }
}
