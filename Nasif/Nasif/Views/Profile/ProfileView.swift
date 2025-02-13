//
//  ProfileView.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 09/01/25.
//

import SwiftUI

@MainActor
class ProfileViewModel: ObservableObject {
    
    @Published var selectedLanguage: String?
    @Published var currentState: ViewState = .none
    @AppStorage(AppStorageKeys.appLanguage) var appLanguage = Constants.defaultLanguage
    @AppStorage(AppStorageKeys.currentContent) var currentContent = ContentScreens.onboarding
    @Published var layoutDirection = LayoutDirection(.leftToRight)
    @Published var user: User?
    
    let nickName: String? = {
        return UserDefaults.standard.string(forKey: "nickname")
    }()
    
    var userId: Int? = {
        return UserDefaults.standard.integer(forKey: "userId")
    }()
    
    init() {
        getUserById(userId: userId)
    }
    
    func changeLanguage(language: String, completion: @escaping () -> ()) {
        guard language != appLanguage else {
            return
        }
        DispatchQueue.main.async {
            self.currentState = .loading
        }
        
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                self.appLanguage = language
                self.selectedLanguage = language
                self.currentState = .none
                self.currentContent = .main
                if language == "ar" {
                    self.layoutDirection = .rightToLeft
                } else {
                    self.layoutDirection = .leftToRight
                }
                completion()
            }
        }
    }
    
    func getUserById(userId: Int? = nil) {
        Task {
            do {
                let response = try await APIClient.shared.callWithStatusCode(.getUserById(id: userId ?? 0), decodeTo: User.self)
                DispatchQueue.main.async {
                    self.user = response.data
                    self.currentState = .none
                    UserDefaults.standard.set(self.user?.userID, forKey: "userId")
                }
            } catch {
                print(error)
                print(error.localizedDescription)
                print("error in fetching user by id")
                currentState = .error(description: error.localizedDescription)
            }
        }
    }
    
    enum ViewState: Equatable {
        case loading
        case none
        case error(description: String)
    }
}

struct ProfileView: View {
    
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    @State var showLanguagePicker: Bool = false
    
    @State var layoutDirection = LayoutDirection(.leftToRight)
    @EnvironmentObject var viewModel: ProfileViewModel
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 36) {
                    Button {
                        isShowingImagePicker = true
                    } label: {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } else {
                            if let image = viewModel.user?.profilePictureURL {
                                CachedImage(imageUrl: image)
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                            } else {
                                Image(.imageSelection)
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    VStack {
                        Text(viewModel.user?.nickname ?? "N/A")
                        Text(viewModel.user?.mobileNumber ?? "N/A")
                            .font(.system(size: 14))
                            .foregroundStyle(.gray)
                    }
                    VStack(spacing: 36) {
                        HStack(spacing: 36) {
                            Button {
                                
                            } label: {
                                Text("Listings")
                                    .foregroundStyle(.white)
                                    .frame(width: 140, height: 70)
                                    .background {
                                        Color.accent
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            Button {
                                
                            } label: {
                                Text("Listings")
                                    .foregroundStyle(.white)
                                    .frame(width: 140, height: 70)
                                    .background {
                                        Color.accent
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        
                        HStack(spacing: 36) {
                            Button {
                                
                            } label: {
                                Text("Deals")
                                    .foregroundStyle(.white)
                                    .frame(width: 140, height: 70)
                                    .background {
                                        Color.accent
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            Button {
                                
                            } label: {
                                Text("Offers")
                                    .foregroundStyle(.white)
                                    .frame(width: 140, height: 70)
                                    .background {
                                        Color.accent
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                    Button {
                        showLanguagePicker.toggle()
                    } label: {
                        Text("Show language selection")
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    logout()
                } label: {
                    HStack {
                        Spacer()
                        Text("Log out")
                            .foregroundStyle(.red)
                    }
                    .padding()
                }
            }
            .padding()
            .onChange(of: selectedImage) { newValue in
                if let newValue {
                    print(newValue.pngData()?.count ?? [])
                }
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(sourceType: .photoLibrary) { image in
                    self.selectedImage = image
                }
            }
            .sheet(isPresented: $showLanguagePicker) {
                LanguagePickerView()
                    .apply {
                        if #available(iOS 16.4, *) {
                            $0
                                .presentationCornerRadius(28)
                                .presentationBackgroundInteraction(.disabled)
                        } else {
                            $0
                        }
                    }
            }
            .environment(\.layoutDirection, viewModel.layoutDirection ?? LayoutDirection.leftToRight)
        }
    }

    private func logout() {
        UserDefaults.standard.userId = nil
        viewModel.user = nil
        viewModel.currentContent = .onboarding
    }
}

#Preview {
    ProfileView()
        .environmentObject(ProfileViewModel())
}
