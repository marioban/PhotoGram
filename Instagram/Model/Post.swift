//
//  Post.swift
//  Instagram
//
//  Created by Mario Ban on 13.02.2024..
//

import Foundation

struct Post: Identifiable, Hashable, Codable {
    let id: String
    let ownerUid: String?
    let caption: String?
    var likes: Int
    var imageUrl: String
    let timeStamp: Date
    var user: User?
}


extension Post {
    static var MOCK_POSTS: [Post] = [
        .init(id: NSUUID().uuidString,
              ownerUid: NSUUID().uuidString,
              caption: "What have I ever done to make you treat me so disrespectfuly",
              likes: 224,
              imageUrl: "vito-corleone",
              timeStamp: Date(),
              user: User.MOCK_USERS[0]),
        
            .init(id: NSUUID().uuidString,
                  ownerUid: NSUUID().uuidString,
                  caption: "F FBI",
                  likes: 224,
                  imageUrl: "sonny-corleone",
                  timeStamp: Date(),
                  user: User.MOCK_USERS[1]),
        
            .init(id: NSUUID().uuidString,
                  ownerUid: NSUUID().uuidString,
                  caption: "Havana",
                  likes: 224,
                  imageUrl: "michael-corleone",
                  timeStamp: Date(),
                  user: User.MOCK_USERS[2]),
        
            .init(id: NSUUID().uuidString,
                  ownerUid: NSUUID().uuidString,
                  caption: "Think about a price",
                  likes: 224,
                  imageUrl: "michael-corleone-price",
                  timeStamp: Date(),
                  user: User.MOCK_USERS[2]),
        
            .init(id: NSUUID().uuidString,
                  ownerUid: NSUUID().uuidString,
                  caption: "",
                  likes: 224,
                  imageUrl: "don-barzini",
                  timeStamp: Date(),
                  user: User.MOCK_USERS[3]),
        
            .init(id: NSUUID().uuidString,
                  ownerUid: NSUUID().uuidString,
                  caption: "",
                  likes: 224,
                  imageUrl: "luca-brasi",
                  timeStamp: Date(),
                  user: User.MOCK_USERS[4])
    ]
}
