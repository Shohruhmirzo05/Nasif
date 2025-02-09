//
//  OTPView.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 09/01/25.
//

import SwiftUI
import Combine
struct OTPView: View {
    @ObservedObject var viewModel: AuthViewModel
    @FocusState private var focused: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Enter Verification Code")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Code sent to +\(viewModel.phoneNumber)")
                .foregroundColor(.gray)
            
            HStack {
                ForEach(0..<6, id: \.self) { index in
                    CodeCell(index)
                }
            }
            .animation(.interpolatingSpring, value: viewModel.isAuthenticated)
            .background {
                TextField("", text: Binding(
                    get: { viewModel.otpString },
                    set: { newValue in
                        let filtered = newValue.filter { $0.isNumber }
                        viewModel.otpCode = Array(repeating: "", count: 6)
                        filtered.prefix(6).enumerated().forEach { index, char in
                            viewModel.otpCode[index] = String(char)
                        }
                    }
                ))
                .focused($focused)
                .textContentType(.oneTimeCode)
                .keyboardType(.numberPad)
                .opacity(0)
            }
            .onChange(of: viewModel.otpString) { newValue in
                if newValue.count == 6 {
                    viewModel.verifyOtp()
                }
            }
            
            TimerView()
            
            if case .error(let message) = viewModel.currentState {
                Text(message)
                    .foregroundColor(.red)
            }
            
            if case .loading = viewModel.currentState {
                ProgressView()
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                viewModel.verifyOtp()
            } label: {
                Text("Confirm")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding()
        .apply { content in
            if #available(iOS 16.0, *) {
                content.navigationDestination(isPresented: $viewModel.showSignUpView) {
                    SignUpUserDetails(viewModel: viewModel)
                }
            }
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
    
    @ViewBuilder func CodeCell(_ index: Int) -> some View {
        let code = viewModel.otpString.map { String($0) }
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.white.opacity(0.0005))
            
            // Border styling
            if code.count > index {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.primary)
            } else if code.count == index {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.accentColor)
            } else {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.secondary)
            }
            
            // Number display
            ZStack {
                if code.count > index {
                    Text(code[index])
                        .animation(.none, value: code.count > index)
                        .transition(.offset(y: 35).combined(with: .opacity))
                }
            }
            .animation(.bouncy.speed(2), value: code.count > index)
        }
        .font(.system(size: 24))
        .padding(0.5)
        .frame(width: 40, height: 52)
        .clipped()
        .frame(maxWidth: .infinity)
        .onTapGesture {
            if !focused {
                focused = true
            }
        }
    }
}
//struct OTPView: View {
//    @FocusState var focusedField: Int?
//    @FocusState var focused: Bool
//    
//    @StateObject var viewModel = AuthViewModel()
//    @Environment(\.dismiss) var dismiss
//    
//    var body: some View {
//        VStack {
//            OTPSection()
//            TimerView()
//        }
//        .padding(.horizontal, 24)
//        .padding(.vertical)
//        .onAppear {
//            focused = true
//            focusedField = 0
//            //            DispatchQueue.main.async {
//            //                UITextField.appearance().textContentType = .oneTimeCode
//            //            }
//            //            viewModel.startTimer()
//        }
//        .onDisappear {
//            // Reset the UITextField appearance to prevent side effects
//            //            DispatchQueue.main.async {
//            //                UITextField.appearance().textContentType = nil
//            //            }
//        }
//        .onChange(of: viewModel.focusedField) { newValue in
//            focusedField = newValue
//        }
//    }
//    
//    @ViewBuilder func OTPSection() -> some View {
//        VStack(spacing: 16) {
//            HStack(spacing: 24) {
//                ForEach(0..<4, id: \.self) { index in
//                    TextField("", text: Binding(
//                        get: { viewModel.otpCode[index] },
//                        set: { newValue in viewModel.handleInput(newValue, at: index) }
//                    ))
//                    .focused($focused)
//                    .frame(width: 50, height: 50)
//                    .keyboardType(.numberPad)
//                    .multilineTextAlignment(.center)
//                    .textFieldStyle(.plain)
//                    .background(
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(viewModel.otpCode[index].isEmpty ? .gray.opacity(0.5) : .accent, lineWidth: 1)
//                            .overlay(content: {
//                                if viewModel.otpCode[index].isEmpty {
//                                    Text("x")
//                                        .opacity(0.2)
//                                }
//                            })
//                    )
//                    .focused($focusedField, equals: index)
//                }
//            }
//        }
//    }
//    
//    @ViewBuilder func NextMove() -> some View {
//        MainButton("Continue") {
//            
//        }
//    }
//    
//    @ViewBuilder func TimerView() -> some View {
//        VStack {
//            if viewModel.canResendCode {
//                Button("I did not receive the verification code") {
//                    viewModel.resendCode()
//                }
//                .foregroundColor(.accentColor)
//            } else {
//                Text("00:\(String(format: "%02d", viewModel.timerValue))")
//                    .foregroundColor(.gray)
//            }
//        }
//        .padding(.top, 8)
//    }
//}

//#Preview {
//    OTPView()
//}
//
//UserDefaults.standard.customerId = customerId
//print("Login successful. Data stored in UserDefaults.")
