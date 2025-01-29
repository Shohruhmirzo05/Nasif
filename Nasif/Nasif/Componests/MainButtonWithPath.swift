//
//  MainButtonWithPath.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 29/01/25.
//


import SwiftUI

struct SmallButtonStyle: ButtonStyle {
    
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .foregroundStyle(isEnabled ? Color.white : Color.secondary.opacity(0.5))
            .background {
                if isEnabled {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.tint.opacity(configuration.isPressed ? 0.8 : 1))
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray4))
                }
            }
    }
}

struct LargeButtonStyle: ButtonStyle {
    
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(12)
            .frame(maxWidth: .infinity)
            .foregroundStyle(isEnabled ? Color.white : Color.secondary.opacity(0.5))
            .background {
                if isEnabled {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.tint.opacity(configuration.isPressed ? 0.8 : 1))
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray4))
                }
            }
    }
}

extension Button {
    
    func smallButton() -> some View {
        buttonStyle(SmallButtonStyle())
    }
    
    func largeButton() -> some View {
        buttonStyle(LargeButtonStyle())
    }
}

#Preview {
    VStack {
        Button {
            
        } label: {
            Text("Large Button")
        }
        .largeButton()
//        .disabled(true)
        .tint(Color.green)
        Button {
            
        } label: {
            Text("Small Button")
        }
        .smallButton()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.red)
}
