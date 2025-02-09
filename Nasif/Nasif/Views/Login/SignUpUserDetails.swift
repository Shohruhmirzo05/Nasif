//
//  UserDetailsView.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 09/01/25.
//

import SwiftUI

//struct SignUpUserDetails: View {
//    @State private var isShowingImagePicker = false
//    @State private var selectedImage: UIImage?
//    
//    @State var name: String = ""
//    
//    var body: some View {
//        VStack(spacing: 36) {
//            Button {
//                isShowingImagePicker = true
//            } label: {
//                if let selectedImage = selectedImage {
//                    Image(uiImage: selectedImage)
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 167, height: 134)
//                        .clipShape(Circle())
//                } else {
//                    Image(.imageSelection)
//                        .resizable()
//                        .frame(width: 167, height: 134)
//                        .foregroundColor(.gray)
//                }
//            }
//            TextField("NickName", text: $name)
//                .padding(.vertical, 12)
//                .padding(.horizontal, 16)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .background {
//                    RoundedRectangle(cornerRadius: 12)
//                        .stroke(lineWidth: 1)
//                        .foregroundStyle(.gray.opacity(0.5))
//                    
//                }
//                .padding(.horizontal)
//            MainButton("Save") {
//                
//            }
//            .padding(.top, 36)
//        }
//        .onChange(of: selectedImage) { newValue in
//            if let newValue {
//                print(newValue.pngData()?.count ?? [])
//            }
//        }
//        .padding(.horizontal, 36)
//        .sheet(isPresented: $isShowingImagePicker) {
//            ImagePicker(sourceType: .photoLibrary) { image in
//                self.selectedImage = image
//            }
//        }
//    }
//}
//
//#Preview {
//    SignUpUserDetails()
//}
struct SignUpUserDetails: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var isShowingImagePicker = false
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Complete Your Profile")
                .font(.title2)
                .fontWeight(.bold)
            
            Button {
                isShowingImagePicker = true
            } label: {
                if let selectedImage = viewModel.selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.gray)
                }
            }
            
            TextField("Nickname", text: $viewModel.nickName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button("Complete Sign Up") {
                viewModel.signUp()
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.currentState == .loading)
            
            if case .loading = viewModel.currentState {
                ProgressView()
            }
            
            if case .error(let message) = viewModel.currentState {
                Text(message)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(sourceType: .photoLibrary) { image in
                viewModel.selectedImage = image
            }
        }
    }
}
