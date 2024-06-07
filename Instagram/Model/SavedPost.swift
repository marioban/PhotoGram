//
//  SavedPost.swift
//  Instagram
//
//  Created by Mario Ban on 06.06.2024..
//

import Foundation
import RealmSwift

class SavedPost: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var ownerUid: String
    @Persisted var caption: String?
    @Persisted var likes: Int
    @Persisted var imageUrl: String
    @Persisted var timeStamp: Date
    @Persisted var didLike: Bool? = false
    
    @Persisted var username: String? = ""
    @Persisted var userProfileImageUrl: String
    
    convenience init(from post: Post) {
        self.init()
        self.ownerUid = post.ownerUid
        self.caption = post.caption
        self.likes = post.likes
        self.imageUrl = post.imageUrl
        self.timeStamp = post.timeStamp.dateValue()
        self.didLike = post.didLike ?? false
        self.username = post.user?.username ?? "unknown"
        self.userProfileImageUrl = post.user?.profileImageUrl ?? ""
    }
    
    convenience init(savedPost: SavedPost) {
        self.init()
        self.ownerUid = savedPost.ownerUid
        self.caption = savedPost.caption
        self.likes = savedPost.likes
        self.imageUrl = savedPost.imageUrl
        self.timeStamp = savedPost.timeStamp
        self.didLike = savedPost.didLike
        self.username = savedPost.username
        self.userProfileImageUrl = savedPost.userProfileImageUrl
    }
}
