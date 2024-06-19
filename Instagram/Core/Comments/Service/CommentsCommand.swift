//
//  CommentsCommand.swift
//  Instagram
//
//  Created by Mario Ban on 19.06.2024..
//

import Foundation

protocol Command {
    func execute() async throws
}

struct UploadCommentCommand: Command {
    private let commentService: CommentService
    private let comment: Comment
    private let post: Post
    
    init(commentService: CommentService, comment: Comment, post: Post) {
        self.commentService = commentService
        self.comment = comment
        self.post = post
    }
    
    func execute() async throws {
        try await commentService.uploadComment(comment)
        NotificationManager.shared.uploadCommentNotification(toUid: comment.postOwnerUid, post: post)
    }
}


struct FetchCommentsCommand: Command {
    private let commentService: CommentService
    private let viewModel: CommentsViewModel
    
    init(commentService: CommentService, viewModel: CommentsViewModel) {
        self.commentService = commentService
        self.viewModel = viewModel
    }
    
    func execute() async throws {
        let comments = try await commentService.fetchComments()
        await viewModel.updateComments(comments: comments)
    }
}
