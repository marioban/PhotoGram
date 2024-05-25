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
    
    //MARK: pull to refresh
    func refreshProfile() {
        do {
            // Re-fetch user stats and potentially other user data
            Task { self.user.stats = try await UserService.fetchUserStats(uid: user.id) }
            Task { self.user = try await UserService.fetchUser(withUid: user.id) } // Assuming this fetches the latest user data
        } catch {
            print("Error refreshing profile: \(error)")
        }
    }
}
