//
//  PostFacade.swift
//  Instagram
//
//  Created by Mario Ban on 19.06.2024..
//

import Foundation
import Firebase

class PostFacade {
    static let shared = PostFacade()
    
    private init() {}
    
    // Fetch feed posts with pagination
    func fetchFeedPosts(startingAfter document: DocumentSnapshot? = nil) async throws -> ([Post], DocumentSnapshot?) {
        return try await PostService.fetchFeedPosts(startingAfter: document)
    }
    
    // Fetch user posts
    func fetchUserPosts(uid: String) async throws -> [Post] {
        return try await PostService.fetchUserPosts(uid: uid)
    }
    
    // Like a post and notify
    func likePost(_ post: Post) async throws {
        try await PostService.likePost(post)
        NotificationManager.shared.uploadLikeNotification(toUid: post.ownerUid, post: post)
    }
    
    // Unlike a post and notify
    func unlikePost(_ post: Post) async throws {
        try await PostService.unlikePost(post)
        await NotificationManager.shared.deleteLikeNotification(notificationOwnerUid: post.ownerUid, post: post)
    }
    
    // Check if user liked a post
    func checkIfUserLikedPost(_ post: Post) async throws -> Bool {
        return try await PostService.checkIfUserLikedPost(post)
    }
    
    // Fetch a specific post
    func fetchPost(_ postId: String) async throws -> Post {
        return try await PostService.fetchPost(postId)
    }
}
