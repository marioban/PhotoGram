//
//  User.swift
//  Instagram
//
//  Created by Mario Ban on 13.02.2024..
//

import Foundation
import Firebase

struct User: Identifiable, Codable, Hashable {
    let id: String
    var username: String
    var profileImageUrl: String?
    var fullname: String?
    var bio: String?
    let email: String
    
    var isCurrentUser: Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else { return false}
        return currentUid == id
    }
}

extension User {
    static var MOCK_USERS: [User] = [
        .init(id: NSUUID().uuidString, username: "vitocorleone", profileImageUrl: nil, fullname: "Vito Corleone", bio: "I'll make you an offer you can't refuse", email: "vitocorleone@mobmail.com"),
        .init(id: NSUUID().uuidString, username: "sonnycorleone", profileImageUrl: nil, fullname: "Sonny Corleone", bio: "Bada bing and it's all over your f suit", email: "sonnycorleone@mobmail.com"),
        .init(id: NSUUID().uuidString, username: "michaelcorleone", profileImageUrl: nil, fullname: "Michael Corleone", bio: "Just when I thought I was out...", email: "vitocorleone@mobmail.com"),
        .init(id: NSUUID().uuidString, username: "don_barzini", profileImageUrl: nil, fullname: "Don Barzini", bio: "", email: "donbarzini@mobmail.com"),
        .init(id: NSUUID().uuidString, username: "luca_brasi", profileImageUrl: nil, fullname: "Luca Brasi", bio: "Sleeping with the fishes", email: "lucabrasi@mobmail.com"),
    ]
}
