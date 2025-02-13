//
//  CreateGroupView.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 13/02/25.
//

import SwiftUI

struct CreateGroupView: View {
    @StateObject var viewModel: MessageViewModel
    @Environment(\.dismiss) var dismiss
    @State private var groupName: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Group Details")) {
                    TextField("Group Name", text: $groupName)
                }
                
                Section {
                    Button(action: createGroup) {
                        Text("Create Group")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(groupName.isEmpty ? .gray : .blue)
                    }
                    .disabled(groupName.isEmpty)
                }
            }
            .navigationTitle("Create New Group")
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            })
        }
    }
    
    private func createGroup() {
        guard let adminId = viewModel.userId else { return }
        
        Task {
            do {
                let response = try await APIClient.shared.call(.createGroup(name: groupName, adminId: adminId), decodeTo: GroupModel.self)
                await MainActor.run {
                    viewModel.groups.append(response)
                    dismiss()
                }
            } catch {
                print("Error creating group: \(error)")
            }
        }
    }
}
