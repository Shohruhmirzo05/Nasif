//
//  OTPView.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 09/01/25.
//


import SwiftUI
import Combine


struct OTPView: View {
    @FocusState var focusedField: Int?
    @FocusState var focused: Bool
    
    @StateObject var viewModel = AuthViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            OTPSection()
            TimerView()
        }
        .padding(.horizontal, 24)
        .padding(.vertical)
        .onAppear {
            focused = true
            focusedField = 0
            //            DispatchQueue.main.async {
            //                UITextField.appearance().textContentType = .oneTimeCode
            //            }
            //            viewModel.startTimer()
        }
        .onDisappear {
            // Reset the UITextField appearance to prevent side effects
            //            DispatchQueue.main.async {
            //                UITextField.appearance().textContentType = nil
            //            }
        }
        .onChange(of: viewModel.focusedField) { newValue in
            focusedField = newValue
        }
    }
    
    @ViewBuilder func OTPSection() -> some View {
        VStack(spacing: 16) {
            HStack(spacing: 24) {
                ForEach(0..<4, id: \.self) { index in
                    TextField("", text: Binding(
                        get: { viewModel.otpCode[index] },
                        set: { newValue in viewModel.handleInput(newValue, at: index) }
                    ))
                    .focused($focused)
                    .frame(width: 50, height: 50)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.plain)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(viewModel.otpCode[index].isEmpty ? .gray.opacity(0.5) : .accent, lineWidth: 1)
                            .overlay(content: {
                                if viewModel.otpCode[index].isEmpty {
                                    Text("x")
                                        .opacity(0.2)
                                }
                            })
                    )
                    .focused($focusedField, equals: index)
                }
            }
        }
    }
    
    @ViewBuilder func NextMove() -> some View {
        MainButton("Continue") {
            
        }
    }
    
    @ViewBuilder func TimerView() -> some View {
        VStack {
            if viewModel.canResendCode {
                Button("I did not receive the verification code") {
                    viewModel.resendCode()
                }
                .foregroundColor(.accentColor)
            } else {
                Text("00:\(String(format: "%02d", viewModel.timerValue))")
                    .foregroundColor(.gray)
            }
        }
        .padding(.top, 8)
    }
}

#Preview {
    OTPView()
}
//
//UserDefaults.standard.customerId = customerId
//print("Login successful. Data stored in UserDefaults.")
