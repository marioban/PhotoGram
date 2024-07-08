//
//  CommentsViewModel.swift
//  Instagram
//
//  Created by Mario Ban on 23.05.2024..
//

import Foundation
import Firebase
import FirebaseFirestoreInternal

@MainActor
class CommentsViewModel: ObservableObject {
    @Published var comments = [Comment]()
    
    private let post: Post
    private let service: CommentService
    
    init(post: Post) {
        self.post = post
        self.service = CommentService(postId: post.id)
        
        Task { try await executeFetchCommentsCommand() }
    }
    
    func uploadComment(commentText: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let comment = Comment(postOwnerUid: post.ownerUid, commentText: commentText, postId: post.id, timestamp: Timestamp(), commentOwnerUid: uid)
        let command = UploadCommentCommand(commentService: service, comment: comment, post: post)
        try await command.execute()
        try await executeFetchCommentsCommand()
    }
    
    func executeFetchCommentsCommand() async throws {
        let command = FetchCommentsCommand(commentService: service, viewModel: self)
        try await command.execute()
    }
    
    func updateComments(comments: [Comment]) async {
        self.comments = comments
        try? await fetchUserDataForComments()
    }
    
    private func fetchUserDataForComments() async throws {
        for i in 0..<comments.count {
            let comment = comments[i]
            let user = try await UserService.fetchUser(withUid: comment.commentOwnerUid)
            comments[i].user = user
        }
    }
}
