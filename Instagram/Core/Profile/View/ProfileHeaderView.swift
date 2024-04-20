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
                Image(user.profileImageUrl ?? "")
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
                }
                
                if let bio = user.bio {
                    Text(bio)
                        .font(.footnote)
                }
                
                Text(user.username)
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
                    .foregroundColor(user.isCurrentUser ? .black : .white)
                    .background(user.isCurrentUser ? .white : Color(.systemBlue))
                    .cornerRadius(6.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(user.isCurrentUser ? .gray : .clear, lineWidth: 1)
                    )
            }
            
            Divider()
        }
        .fullScreenCover(isPresented: $showEditProfile, content: {
            Text("edit profile view")
        })
    }
}

#Preview {
    ProfileHeaderView(user: User.MOCK_USERS[0])
}
