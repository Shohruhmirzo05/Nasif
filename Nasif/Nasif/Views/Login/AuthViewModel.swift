//
//  RegistrationViewMode;.swift
//  ValidationComponents
//
//  Created by Shohruhmirzo Alijonov on 19/12/24.
//

import SwiftUI
import Combine

struct AuthResponse: Codable {
    let status, message: String
}

struct SignUpResponse: Codable {
    let message: String
}

struct RegistrationModel: Identifiable, Codable {
    var id: String
    var userPhoneNumber: String
    
    static let mock = RegistrationModel(id: UUID().uuidString, userPhoneNumber: "")
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var otpCode: [String] = Array(repeating: "", count: 6)
    @Published var focusedField: Int? = 0
    @Published var timerValue: Int = 59
    @Published var canResendCode: Bool = false
    
    @Published var phoneNumber: String = ""
    @Published var otpCodeString: String = ""
    
    @Published var currentState: ViewState = .loading
    @Published var authResponse: AuthResponse?
    @Published var signUpResponse: SignUpResponse?
    
    @Published var nickName: String = ""
    @Published var profilePictureUrl: String = ""

    private var timerCancellable: AnyCancellable?

    init() {
        startTimer()
    }
    
//    UserDefaults.standard.customerId = customerId
    
    func sendLoginNumber() {
        currentState = .loading
        Task {
            do {
                let response = try await APIClient.shared.callWithStatusCode(.sendNumberForLogin(phoneNumber: "+919" + phoneNumber), decodeTo: AuthResponse.self)
                DispatchQueue.main.async {
                    self.authResponse = response.data
                    self.currentState = .success
                    print("✅ otp code is sent: \(response.data)")
                }
            } catch {
                DispatchQueue.main.async {
                    print("error in sending otp code: \(error.localizedDescription)")
                    print(error)
                    self.currentState = .error(error.localizedDescription)
//                    UserDefaults.standard.customerId = customerId
                }
            }
        }
    }
    
    func verifyOtp() {
        currentState = .loading
        Task {
            do {
                let response = try await APIClient.shared.callWithStatusCode(.verifyOTP(phoneNumber: "+966" + phoneNumber, otpCode: otpCodeString), decodeTo: AuthResponse.self)
                DispatchQueue.main.async {
                    self.authResponse = response.data
                    self.currentState = .success
                    print("✅ otp verified successfully: \(response.data)")
                }
            } catch {
                print(error)
                print(error.localizedDescription)
                currentState = .error(error.localizedDescription)
            }
        }
    }
    
    func signUp() {
        currentState = .loading
        Task {
            do {
                let response = try await APIClient.shared.callWithStatusCode(.signUp(phoneNumber: "+966" + phoneNumber, nickName: nickName, profilePictureUrl: profilePictureUrl), decodeTo: SignUpResponse.self)
                DispatchQueue.main.async {
                    self.signUpResponse = response.data
                    self.currentState = .success
                    print("✅ user signed up successfully: \(response.data)")
                }
            } catch {
                print(error)
                print(error.localizedDescription)
                currentState = .error(error.localizedDescription)
            }
        }
    }
    
    
    var isPhoneNumberValid: Bool {
        phoneNumber.filter { $0.isWholeNumber }.count == 9
    }

    func startTimer() {
        canResendCode = false
        timerValue = 59
        timerCancellable?.cancel()
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.timerValue > 0 {
                    self.timerValue -= 1
                } else {
                    self.timerCancellable?.cancel()
                    self.canResendCode = true
                }
            }
    }

    func resendCode() {
        startTimer()
    }

    func handleInput(_ value: String, at index: Int) {
        if value.isEmpty && !otpCode[index].isEmpty {
            handleBackspace(at: index)
        } else {
            otpCode[index] = String(value.prefix(1))
            if !value.isEmpty && index < otpCode.count - 1 {
                focusedField = index + 1
            }
        }
    }

    func handleBackspace(at index: Int) {
        otpCode[index] = ""
        if index > 0 {
            focusedField = index - 1
        }
    }
    
    enum ViewState: Equatable {
        case loading
        case success
        case error(_ description: String)
    }
}

