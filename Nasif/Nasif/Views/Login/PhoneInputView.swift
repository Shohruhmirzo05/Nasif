//
//  SignUpView.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 09/01/25.
//

import SwiftUI

struct PhoneInputView: View {
    
//    @State var phoneNumber: String = ""
    @StateObject var viewModel = AuthViewModel()
    @State var showOTPView: Bool = false
    
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
                        Text("+966")
                        TextField("", text: $viewModel.phoneNumber)
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
                MainButton("Continue") {
                    viewModel.sendLoginNumber()
                    showOTPView = true
                }
                .padding(.top, 36)
                .padding(.horizontal, 24)
                NavigationLink(destination: OTPView(), isActive: $showOTPView) {
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .navigationDestination(isPresented: $showOTPView) {
//
//            }
        }
        
    }
}

#Preview {
    PhoneInputView()
}
