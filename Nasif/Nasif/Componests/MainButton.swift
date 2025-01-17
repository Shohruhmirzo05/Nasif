//
//  MainButton.swift
//  ValidationComponents
//
//  Created by Shohruhmirzo Alijonov on 12/12/24.
//


import SwiftUI

struct MainButton<Content: View>: View {
    
    let action: () -> Void
    let backgroundColor: Color
    let buttonForegroundStyle: Color
    let title: LocalizedStringKey?
    @ViewBuilder let content: () -> Content
    
    init(
        _ title: LocalizedStringKey,
        backgroundColor: Color = .accentColor,
        buttonForegroundStyle: Color = .white,
        action: @escaping () -> Void
    ) where Content == EmptyView {
        self.title = title
        self.action = action
        self.backgroundColor = backgroundColor
        self.buttonForegroundStyle = buttonForegroundStyle
        self.content = { EmptyView() }
    }
    
    init(
        backgroundColor: Color = .accentColor,
        buttonForegroundStyle: Color = .white,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = nil
        self.action = action
        self.backgroundColor = backgroundColor
        self.buttonForegroundStyle = buttonForegroundStyle
        self.content = content
    }
    
    var body: some View {
        Button(action: action) {
            if let title = title {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12.5)
            } else {
                content()
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12.5)
            }
        }
        .buttonStyle(MainButtonStyle(backgroundColor: backgroundColor, buttonForegroundStyle: buttonForegroundStyle))
    }
}



struct MainNavigationLink<Destination: View>: View {
    
    let title: LocalizedStringKey
    let destination: Destination
    let backgroundColor: Color
    
    init(_ title: LocalizedStringKey, backgroundColor: Color = .accentColor, @ViewBuilder destination: () -> Destination) {
        self.title = title
        self.destination = destination()
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        NavigationLink(destination: destination) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12.5)
        }
        .buttonStyle(MainButtonStyle(backgroundColor: backgroundColor)) // Reuse your MainButton style
    }
}

#Preview {
//    MainButton("Skip", buttonForegroundStyle: .black) {
//        
//    }
//    Button("Skip") {
//        
//    }
//    .buttonStyle(.borderedProminent)
    PhoneInputView()
}

//#Preview {
////    NavigationView {
////        MainNavigationLink("Go to somewhere") {
////            Text("Hello")
////        }
////        .disabled(true)
////    }
//    PhoneInputView()
//}

struct MainButtonStyle: ButtonStyle {
    
    @Environment(\.isEnabled) var isEnabled
    var backgroundColor: Color
    var buttonForegroundStyle: Color
    
    init(backgroundColor: Color = .accentColor, buttonForegroundStyle: Color = .accent) {
        self.backgroundColor = backgroundColor
        self.buttonForegroundStyle = buttonForegroundStyle
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        
        configuration.label
            .padding(.horizontal, 12)
            .foregroundStyle(isEnabled ? buttonForegroundStyle : Color.secondary.opacity(0.5))
            .background {
                if isEnabled {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(backgroundColor.opacity(configuration.isPressed ? 0.8 : 1))
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray4))
                }
            }
    }
}
