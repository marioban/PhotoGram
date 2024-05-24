//
//  Comment.swift
//  Instagram
//
//  Created by Mario Ban on 23.05.2024..
//

import Foundation
import Firebase
import FirebaseFirestore

struct Comment: Identifiable, Codable {
    
    @DocumentID var commentId: String?
    let postOwnerUid: String
    let commentText: String
    let postId: String
    let timestamp: Timestamp
    let commentOwnerUid: String
    var user: User?
    var id: String {
        return commentId ?? NSUUID().uuidString
    }
    
}
