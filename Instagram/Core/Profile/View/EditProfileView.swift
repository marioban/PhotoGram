//
//  EditProfileView.swift
//  Instagram
//
//  Created by Mario Ban on 06.03.2024..
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: EditProfileViewModel
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: EditProfileViewModel(user: user))
    }
    
    var body: some View {
        VStack {
            // Toolbar
            VStack {
                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color.primary)
                    
                    Spacer()
                    
                    Text("Edit Profile")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.primary)
                    
                    Spacer()
                    
                    Button {
                        Task { try await viewModel.updateUserData() }
                        dismiss()
                    } label: {
                        Text("Done")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(Color.primary)
                }
                .padding(.horizontal)
                
                Divider()
            }
            
            // Edit profile pic
            PhotosPicker(selection: $viewModel.selectedImage) {
                VStack {
                    if let image = viewModel.profileImage {
                        image
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 80, height: 80)
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    } else {
                        CircularProfileImageView(user: viewModel.user,size: .large)
                    }
                    
                    Text("Edit Profile Picture")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.primary)
                }
            }
            .padding(.vertical, 8)
            
            // Edit profile info
            VStack {
                EditProfileRowView(title: "Name", placeholder: "Enter your name", text: $viewModel.fullname)
                EditProfileRowView(title: "Bio", placeholder: "Enter your bio", text: $viewModel.bio)
            }
            
            Spacer()
        }
    }
}

struct EditProfileRowView: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Text(title)
                .padding(.leading, 8)
                .frame(width: 100, alignment: .leading)
                .foregroundColor(Color.primary)
            
            VStack {
                TextField(placeholder, text: $text)
                    .foregroundColor(Color.primary)
                    .textFieldStyle(PlainTextFieldStyle())  
                
                Divider()
            }
        }
        .font(.subheadline)
        .frame(height: 36)
    }
}

#Preview {
    EditProfileView(user: User.MOCK_USERS[0])
}
