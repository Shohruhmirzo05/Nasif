//
//  LanguageSelectionView.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 09/01/25.
//

import SwiftUI

struct LanguagePickerView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ProfileViewModel()
    
    var body: some View {
        VStack(spacing: 18) {
            HStack {
                Text("Choose language")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "circle.fill")
                        .tint(Color.black.opacity(0.1))
                        .font(.title)
                        .overlay {
                            Image(systemName: "xmark")
                                .tint(.black)
                                .fontWeight(.semibold)
                        }
                }
            }
            .padding(.top, 19)
            CardBackground {
                VStack {
                    ForEach(Constants.languages) { language in
                        Button {
                            viewModel.selectedLanguage = language.identifier
                            viewModel.changeLanguage(language: language.identifier) {
                                dismiss()
                            }
                            print(viewModel.selectedLanguage ?? "")
                        } label: {
                            VStack(spacing: 14) {
                                HStack {
                                    Text(language.name)
                                        .font(.system(size: 18))
                                        .foregroundColor(.primary)
                                        .padding(4)
                                    Spacer()
                                    if viewModel.selectedLanguage == language.identifier {
                                        Image(systemName: "circle.fill")
                                            .font(.title2)
                                            .tint(.accent)
                                            .overlay {
                                                Image(systemName: "circle.fill")
                                                    .font(.caption2)
                                                    .tint(.white)
                                            }
                                    } else {
                                        Image(systemName: "circle")
                                            .font(.title2)
                                    }
                                }
                                Divider()
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

