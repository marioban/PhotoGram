//
//  ProfileHeaderView.swift
//  Instagram
//
//  Created by Mario Ban on 14.02.2024..
//

import SwiftUI

struct ProfileHeaderView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var showEditProfile = false
    
    private var isFollowed: Bool {
        return user.isFollowed ?? false
    }
    
    private var user: User {
        return viewModel.user
    }
    
    private var buttonTitle: String {
        if user.isCurrentUser {
            return "Edit Profile"
        } else {
            return isFollowed ? "Following" : "Follow"
        }
    }
    
    init(user: User) {
        self.viewModel = ProfileViewModel(user: user)
    }
    
    var body: some View {
        
        VStack(spacing: 10) {
            // MARK: Profile pic and stats
            HStack {
                CircularProfileImageView(user: user,size: .large)
                
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
                
                Text(user.fullname ?? "")
                    .font(.footnote)
                    .fontWeight(.semibold)
                
                if let bio = user.bio {
                    Text(bio)
                        .font(.footnote)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            //edit button
            Button {
                if user.isCurrentUser {
                    showEditProfile.toggle()
                } else {
                    handleFollowTapped()
                }
            } label: {
                Text(buttonTitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(width: 360,height: 32)
                    .foregroundColor(.white)
                    .background(user.isCurrentUser ? Color.gray : Color.blue)
                    .cornerRadius(6.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(user.isCurrentUser ? Color.gray : .clear, lineWidth: 1)
                    )
            }
            
            Divider()
        }
        .fullScreenCover(isPresented: $showEditProfile, content: {
            EditProfileView(user: user)
        })
    }
    
    func handleFollowTapped() {
        if isFollowed {
            viewModel.unfollow()
        } else {
            viewModel.follow()
        }
    }
}

#Preview {
    ProfileHeaderView(user: User.MOCK_USERS[0])
}
