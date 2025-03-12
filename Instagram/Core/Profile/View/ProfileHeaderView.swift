//
//  ProfileHeaderView.swift
//  Instagram
//
//  Created by Mario Ban on 14.02.2024..
//

import SwiftUI

struct ProfileHeaderView: View, ProfileComponent {
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
    
    private var buttonBackgroundColor: Color {
        if user.isCurrentUser || isFollowed {
            return .white
        } else {
            return Color(.systemBlue)
        }
    }
    
    private var buttonForegroundColor: Color {
        if user.isCurrentUser || isFollowed {
            return .black
        } else {
            return .white
        }
    }
    
    private var buttonBorderColor: Color {
        if user.isCurrentUser || isFollowed {
            return .gray
        } else {
            return .clear
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
                    UserStatView(value: user.stats?.postCount ?? 0, title: "Posts")
                    
                    NavigationLink(value: UserList.followers(uid: user.id)) {
                        UserStatView(value: user.stats?.followersCount ?? 0, title: "Followers")
                    }
                    
                    NavigationLink(value: UserList.following(uid: user.id)) {
                        UserStatView(value: user.stats?.followingCount ?? 0, title: "Following")
                    }
                    
                }
            }
            .padding(.horizontal)
            
            //MARK: Name and bio
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.user.fullname ?? "")
                    .font(.title2)
                    .fontWeight(.bold)
                
                if let bio = viewModel.user.bio {
                    Text(bio)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading,20)
            
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
                    .frame(width: 360, height: 30)
                    .foregroundColor(buttonForegroundColor)
                    .background(buttonBackgroundColor)
                    .cornerRadius(6)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.gray, lineWidth: 1))
            }
            
            Divider()
        }
        .navigationDestination(for: UserList.self, destination: { config in
            UserListView(config: config, searchViewModel: SearchViewModel())
        })
        .onAppear(perform: {
            Task {
                await viewModel.refreshProfile()
            }
        })
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
    
    func render() -> AnyView {
        AnyView(self)
    }
}

#Preview {
    ProfileHeaderView(user: User.MOCK_USERS[0])
}
