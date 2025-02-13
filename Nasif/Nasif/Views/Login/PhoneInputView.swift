//
//  SignUpView.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 09/01/25.
//

import SwiftUI
struct PhoneInputView: View {
    @StateObject var viewModel = AuthViewModel()
    @State private var showOTPView: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 36) {
                Text("Phone Number")
                    .font(.abel(size: 24))
                
                HStack {
                    Image(.arabicNumberIcon)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(.leading)
                        .overlay {
                            Rectangle()
                                .fill(.gray)
                                .frame(width: 1)
                                .rotationEffect(.degrees(180))
                                .padding(.leading, 88)
                        }
                    
                    HStack {
                        Text("+91")
                        TextField("Enter phone number", text: $viewModel.phoneNumber)
                            .keyboardType(.numberPad)
                    }
                    .font(.abel(size: 16))
                    .padding(.leading)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 1)
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal, 36)
                
                Button {
                    viewModel.sendLoginNumber()
                    showOTPView = true
                } label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.top, 36)
                .padding(.horizontal, 24)
                
                NavigationLink(
                    destination: OTPView(viewModel: viewModel),
                    isActive: $showOTPView
                ) {
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                if case .loading = viewModel.currentState {
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
            .alert(
                "Error",
                isPresented: .init(
                    get: {
                        if case .error = viewModel.currentState { return true }
                        return false
                    },
                    set: { _ in }
                )
            ) {
                Button("OK") {
                    viewModel.currentState = .idle
                }
            } message: {
                if case let .error(message) = viewModel.currentState {
                    Text(message)
                }
            }
        }
    }
}


#Preview {
    PhoneInputView()
}


struct OTPTextField: View {
    let index: Int
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        TextField("", text: Binding(
            get: { viewModel.otpCode[index] },
            set: { newValue in
                if newValue.count <= 1 {
                    viewModel.otpCode[index] = newValue
                    if !newValue.isEmpty && index < 5 {
                        viewModel.focusedField = index + 1
                    }
                }
            }
        ))
        .keyboardType(.numberPad)
        .multilineTextAlignment(.center)
        .frame(width: 45, height: 45)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(viewModel.otpCode[index].isEmpty ? .gray : .blue, lineWidth: 1)
        )
        .onChange(of: viewModel.focusedField) { newValue in
            if newValue == index {
                viewModel.otpCode[index] = ""
            }
        }
    }
}
