//
//  RegistrationViewMode;.swift
//  ValidationComponents
//
//  Created by Shohruhmirzo Alijonov on 19/12/24.
//

import SwiftUI
import Combine

struct RegistrationModel: Identifiable, Codable {
    var id: String
    var userPhoneNumber: String
    
    static let mock = RegistrationModel(id: UUID().uuidString, userPhoneNumber: "")
}

class RegistrationViewModel: ObservableObject {
    @Published var otpCode: [String] = Array(repeating: "", count: 6) // OTP digits array
    @Published var focusedField: Int? = 0 // Keeps track of the currently focused field
    @Published var timerValue: Int = 59
    @Published var canResendCode: Bool = false // Enables resend button
    @Published var phoneNumber: String = ""

    private var timerCancellable: AnyCancellable? // Timer subscription

    init() {
        startTimer()
    }
    var isPhoneNumberValid: Bool {
        phoneNumber.filter { $0.isWholeNumber }.count == 9 // Assumes valid phone numbers have 9 digits
    }
//
//    var formattedPhoneNumber: String {
//        phoneNumber.formattedPhoneNumber
//    }
//    
//    var dynamicPlaceholder: String {
//        phoneNumber.dynamicPlaceholder
//    }
    // Start the countdown timer
    func startTimer() {
        canResendCode = false
        timerValue = 59
        timerCancellable?.cancel() // Stop any existing timer
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

    // Resend code functionality
    func resendCode() {
        // Add logic to resend OTP
        startTimer()
    }

    // Handle input for an OTP digit
    func handleInput(_ value: String, at index: Int) {
        if value.isEmpty && !otpCode[index].isEmpty {
            handleBackspace(at: index)
        } else {
            otpCode[index] = String(value.prefix(1)) // Limit to 1 digit
            if !value.isEmpty && index < otpCode.count - 1 {
                focusedField = index + 1 // Move to the next field
            }
        }
    }

    // Handle backspace navigation
    func handleBackspace(at index: Int) {
        otpCode[index] = "" // Clear the current field
        if index > 0 {
            focusedField = index - 1 // Move to the previous field
        }
    }
}

