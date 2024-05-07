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
                    .foregroundColor(Color.primary)  // Adaptable text color for buttons
                    
                    Spacer()
                    
                    Text("Edit Profile")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.primary)  // Adaptable text color for titles
                    
                    Spacer()
                    
                    Button {
                        print("Update profile info")
                    } label: {
                        Text("Done")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(Color.primary)  // Adaptable text color for buttons
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
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))  // Added a border to highlight the image
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(Color.primary)  // Adaptable icon color
                            .background(Color.secondary)  // Adaptable background for better contrast
                            .clipShape(Circle())
                            .frame(width: 80, height: 80)
                    }
                    
                    Text("Edit Profile Picture")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.primary)  // Adaptable text color
                }
            }
            .padding(.vertical, 8)
            
            // Edit profile info
            VStack {
                EditProfileRowView(title: "Name", placeholder: "Enter your name", text: $viewModel.name)
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
                .foregroundColor(Color.primary)  // Adaptable text color
            
            VStack {
                TextField(placeholder, text: $text)
                    .foregroundColor(Color.primary)  // Adaptable text color
                    .textFieldStyle(PlainTextFieldStyle())  // Removing style to apply custom
                
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
