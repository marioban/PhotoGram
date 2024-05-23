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
    let timeStamp: Timestamp
    var user: User?
    
    var didLike: Bool? = false
}


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
