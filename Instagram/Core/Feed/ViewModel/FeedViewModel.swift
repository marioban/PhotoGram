//
//  FeedViewModel.swift
//  Instagram
//
//  Created by Mario Ban on 21.05.2024..
//

import Foundation
import Firebase

class FeedViewModel: ObservableObject {
    @Published var posts = [Post]()
    @Published var isLoading = false
    private var lastDocumentSnapshot: DocumentSnapshot?
    
    init() {
        Task{ await loadMorePosts()}
    }
    
    @MainActor
    func loadMorePosts() async {
        guard !isLoading else { return }
        isLoading = true
        
        do {
            let (newPosts, lastSnapshot) = try await PostService.fetchFeedPosts(startingAfter: lastDocumentSnapshot)
            lastDocumentSnapshot = lastSnapshot
            posts.append(contentsOf: newPosts)
        } catch let error {
            print("Error loading more posts: \(error)")
        }
        
        isLoading = false
    }
}
