//
//  PostGridViewModel.swift
//  Instagram
//
//  Created by Mario Ban on 22.05.2024..
//

import Foundation

@MainActor
class PostGridViewModel: ObservableObject {
    private let user: User
    @Published var posts = [Post]()
    
    init(user: User) {
        self.user = user
        Task { try await fetchUserPosts() }
    }
    
    func fetchUserPosts() async throws {
        self.posts = try await PostService.fetchUserPosts(uid: user.id)
        
        for i in 0 ..< posts.count {
            posts[i].user = self.user
        }
    }
}
