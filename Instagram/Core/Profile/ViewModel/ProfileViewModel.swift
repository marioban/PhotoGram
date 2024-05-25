//
//  ProfileViewModel.swift
//  Instagram
//
//  Created by Mario Ban on 24.05.2024..
//

import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var user: User
    
    init(user: User) {
        self.user = user
    }
    
    //MARK: Following
    func follow()  {
        Task {
            try await UserService.follow(uid: user.id)
            user.isFollowed = true
        }
    }
    
    func unfollow()  {
        Task {
            try await UserService.unfollow(uid: user.id)
            user.isFollowed = false
        }
    }
    
    func checkIfUserIsFollowed()  {
        Task {
            self.user.isFollowed = try await UserService.checkIfUserIsFollowed(uid: user.id)
        }
    }
    
    //MARK: user stats
    func fetchUserStats() {
        Task {
            self.user.stats = try await UserService.fetchUserStats(uid: user.id)
        }
    }
    
    func refreshProfile() async {
        do {
            // Fetch latest user data
            let updatedUser = try await UserService.fetchUser(withUid: user.id)
            let updatedStats = try await UserService.fetchUserStats(uid: user.id)
            let isFollowed = try await UserService.checkIfUserIsFollowed(uid: user.id)
            
            // Update all properties at once to ensure UI consistency
            DispatchQueue.main.async { [weak self] in
                self?.user = updatedUser
                self?.user.stats = updatedStats
                self?.user.isFollowed = isFollowed
            }
        } catch {
            print("Error refreshing profile: \(error)")
        }
    }
}
