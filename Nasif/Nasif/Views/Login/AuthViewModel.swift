//
//  RegistrationViewMode;.swift
//  ValidationComponents
//
//  Created by Shohruhmirzo Alijonov on 19/12/24.
//

import SwiftUI
import Combine

struct UserDefaultsKeys {
    static let accessToken = "accessToken"
    static let userId = "userId"
}

extension UserDefaults {
    var accessToken: String? {
        get { string(forKey: UserDefaultsKeys.accessToken) }
        set { set(newValue, forKey: UserDefaultsKeys.accessToken) }
    }

    var userId: Int? {
        get { integer(forKey: UserDefaultsKeys.userId) }
        set { set(newValue, forKey: UserDefaultsKeys.userId) }
    }
}

struct AuthResponse: Codable {
    let status, message: String
    let data: AuthResponseData?
}

struct AuthResponseData: Codable {
    let token: String?
    let phone: String?
    let userId: Int?
    
    enum CodingKeys: String, CodingKey {
        case token, phone
        case userId = "user_id"
    }
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
    @Published var nickName: String = ""
    @Published var profilePictureUrl: String = ""
    @Published var selectedImage: UIImage?
    
    @Published var currentState: ViewState = .idle
    @Published var authResponse: AuthResponse?
    @Published var signUpResponse: SignUpResponse?
    @Published var user: User?
    
    @Published var showSignUpView: Bool = false
    @Published var isAuthenticated: Bool = false
    
    private var timerCancellable: AnyCancellable?
    
    let userId: Int? = {
        return UserDefaults.standard.integer(forKey: "userId")
    }()
    
    var otpString: String {
        otpCode.joined()
    }
    @AppStorage(AppStorageKeys.currentContent) var currentContent = ContentScreens.onboarding
    
    init() {
        getUserById(userId: /*userId*/ 1)
    }
    
    func getUserById(userId: Int? = nil) {
        Task {
            do {
                let response = try await APIClient.shared.callWithStatusCode(.getUserById(id: userId ?? 0), decodeTo: User.self)
                DispatchQueue.main.async {
                    self.user = response.data
                   
                    UserDefaults.standard.set(self.user?.userID, forKey: "userId")
                }
            } catch {
                print(error)
                print(error.localizedDescription)
                print("error in fetching user by id")
                currentState = .error(error.localizedDescription)
            }
        }
    }

    func sendLoginNumber() {
        guard isPhoneNumberValid else {
            currentState = .error("Invalid phone number")
            return
        }
        
        currentState = .loading
        Task {
            do {
                let response = try await APIClient.shared.callWithStatusCode(
                    .sendNumberForLogin(phoneNumber: "+91" + phoneNumber),
                    decodeTo: AuthResponse.self
                )
                self.authResponse = response.data
                self.currentState = .success
                startTimer()
            } catch {
                self.currentState = .error(error.localizedDescription)
            }
        }
    }
    
    func verifyOtp() {
        guard otpString.count == 6 else {
            currentState = .error("Please enter complete OTP")
            return
        }
        
        currentState = .loading
        Task {
            do {
                let response = try await APIClient.shared.callWithStatusCode(
                    .verifyOTP(phoneNumber: "+91" + phoneNumber, otpCode: otpString),
                    decodeTo: AuthResponse.self
                )
                if response.statusCode == 200 {
                    self.authResponse = response.data
                    self.currentState = .success
                    self.isAuthenticated = true
                    self.currentContent = .main
                    UserDefaults.standard.userId = response.data.data?.userId
                    print("Login successful. Data stored in UserDefaults.")
                    self.getUserById(userId: response.data.data?.userId ?? 0)
                } else if response.statusCode == 404 {
                    self.showSignUpView = true
                }
            } catch {
                currentState = .error(error.localizedDescription)
            }
        }
    }
    
    func signUp() {
        guard !nickName.isEmpty else {
            currentState = .error("Please enter a nickname")
            return
        }
        
        currentState = .loading
        Task {
            do {
                var imageUrl = ""
                if let image = selectedImage {
                    imageUrl = await uploadImage(image) ?? ""
                }
                
                let response = try await APIClient.shared.callWithStatusCode(
                    .signUp(
                        phoneNumber: "+91" + phoneNumber,
                        nickName: nickName,
                        profilePictureUrl: imageUrl
                    ),
                    decodeTo: SignUpResponse.self
                )
                self.signUpResponse = response.data
                self.currentState = .success
                self.currentContent = .main
                self.isAuthenticated = true
            } catch {
                currentState = .error(error.localizedDescription)
            }
        }
    }
    
    private func uploadImage(_ image: UIImage) async -> String? {
        // Implement image upload logic here
        // Return the URL of the uploaded image
        return nil
    }
    
    enum ViewState: Equatable {
        case idle
        case loading
        case success
        case error(String)
    }
    
    var isPhoneNumberValid: Bool {
        phoneNumber.filter { $0.isWholeNumber }.count >= 1
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
}
