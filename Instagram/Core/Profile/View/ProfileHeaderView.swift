//
//  ProfileHeaderView.swift
//  Instagram
//
//  Created by Mario Ban on 14.02.2024..
//

import SwiftUI

struct ProfileHeaderView: View {
    
    let user: User
    
    @State private var showEditProfile = false
    
    var body: some View {
        
        VStack(spacing: 10) {
            // MARK: Profile pic and stats
            HStack {
                Image(user.profileImageUrl ?? "default_profile")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                
                Spacer()
                
                HStack(spacing: 8) {
                    UserStatView(value: 3, title: "Posts")
                    UserStatView(value: 25, title: "Followers")
                    UserStatView(value: 25, title: "Following")
                }
            }
            .padding(.horizontal)
            
            //MARK: Name and bio
            VStack(alignment: .leading, spacing: 4) {
                
                if let fullName = user.fullName {
                    Text(fullName)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.primary)  // Adaptive text color
                }
                
                if let bio = user.bio {
                    Text(bio)
                        .font(.footnote)
                        .foregroundColor(Color.secondary)  // Less emphasized text color
                }
                
                Text(user.username)
                    .foregroundColor(Color.primary)  // Adaptive text color
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            //edit button
            Button {
                if user.isCurrentUser {
                    showEditProfile.toggle()
                } else {
                    print("Follow user")
                }
            } label: {
                Text(user.isCurrentUser ? "Edit Profile" : "Follow")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(width: 360,height: 32)
                    .foregroundColor(.white) // Consistent text color for buttons
                    .background(user.isCurrentUser ? Color.gray : Color.blue) // Adaptive button background
                    .cornerRadius(6.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray, lineWidth: 1) // Consistent border color
                    )
            }
            
            Divider()
        }
        .fullScreenCover(isPresented: $showEditProfile, content: {
            Text("edit profile view")  // Placeholder for actual edit view
        })
    }
}

#Preview {
    ProfileHeaderView(user: User.MOCK_USERS[0])
}
