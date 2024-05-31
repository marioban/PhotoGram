//
//  Notification.swift
//  Instagram
//
//  Created by Mario Ban on 30.05.2024..
//

import Foundation
import Firebase

struct Notification: Identifiable, Codable {
    let id: String
    var postId: String?
    let timestamp: Timestamp
    let notificationSenderUid: String
    let type: NotificationType
    
    var post: Post?
    var user: User?
}


enum NotificationType: Int, Codable {
    case like
    case comment
    case follow
    
    var notificationMessage: String {
        switch self {
        case .like:
            return "liked your post."
        case .comment:
            return "commented on your post."
        case .follow:
            return "started following you."
        }
    }
}
