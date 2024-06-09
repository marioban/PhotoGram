//
//  Post.swift
//  Instagram
//
//  Created by Mario Ban on 13.02.2024..
//

import Foundation
import Firebase

struct Post: Identifiable, Hashable, Codable {
    let id: String
    let ownerUid: String
    let caption: String?
    var likes: Int
    var imageUrl: String
    let timeStamp: Timestamp?
    var user: User?
    
    var didLike: Bool? = false
    var didSave: Bool? = false
    
    init(id: String, ownerUid: String, caption: String?, likes: Int, imageUrl: String, timeStamp: Timestamp?) {
        self.id = id
        self.ownerUid = ownerUid
        self.caption = caption
        self.likes = likes
        self.imageUrl = imageUrl
        self.timeStamp = timeStamp
        self.user = nil
        self.didLike = false
        self.didSave = false
    }
    
    // Adding an initializer to create a Post from a SavedPost
    init(from savedPost: SavedPost) {
        self.id = savedPost.id
        self.ownerUid = savedPost.ownerUid
        self.caption = savedPost.caption
        self.likes = savedPost.likes
        self.imageUrl = savedPost.imageUrl
        self.timeStamp = savedPost.timeStamp != nil ? Timestamp(date: savedPost.timeStamp!) : nil
        self.didLike = savedPost.didLike
        self.user = User(id: savedPost.ownerUid, username: savedPost.username ?? "unknown", profileImageUrl: savedPost.userProfileImageUrl, email: "")
        self.didSave = true
    }
}

/*
extension Post {
    static var MOCK_POSTS: [Post] = [
        .init(id: NSUUID().uuidString,
              ownerUid: NSUUID().uuidString,
              caption: "What have I ever done to make you treat me so disrespectfuly",
              likes: 224,
              imageUrl: "vito-corleone",
              timeStamp: Timestamp(),
              user: User.MOCK_USERS[0]),
        
            .init(id: NSUUID().uuidString,
                  ownerUid: NSUUID().uuidString,
                  caption: "F FBI",
                  likes: 224,
                  imageUrl: "sonny-corleone",
                  timeStamp: Timestamp(),
                  user: User.MOCK_USERS[1]),
        
            .init(id: NSUUID().uuidString,
                  ownerUid: NSUUID().uuidString,
                  caption: "Havana",
                  likes: 224,
                  imageUrl: "michael-corleone",
                  timeStamp: Timestamp(),
                  user: User.MOCK_USERS[2]),
        
            .init(id: NSUUID().uuidString,
                  ownerUid: NSUUID().uuidString,
                  caption: "Think about a price",
                  likes: 224,
                  imageUrl: "michael-corleone-price",
                  timeStamp: Timestamp(),
                  user: User.MOCK_USERS[2]),
        
            .init(id: NSUUID().uuidString,
                  ownerUid: NSUUID().uuidString,
                  caption: "",
                  likes: 224,
                  imageUrl: "don-barzini",
                  timeStamp: Timestamp(),
                  user: User.MOCK_USERS[3]),
        
            .init(id: NSUUID().uuidString,
                  ownerUid: NSUUID().uuidString,
                  caption: "",
                  likes: 224,
                  imageUrl: "luca-brasi",
                  timeStamp: Timestamp(),
                  user: User.MOCK_USERS[4])
    ]
}
*/
