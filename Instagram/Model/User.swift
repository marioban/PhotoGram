//
//  User.swift
//  Instagram
//
//  Created by Mario Ban on 13.02.2024..
//

import Foundation

struct User: Identifiable, Codable, Hashable {
    let id: String
    var username: String
    var profileImageUrl: String?
    var fullName: String?
    var bio: String?
    let email: String?
}

extension User {
    static var MOCK_USERS: [User] = [
        .init(id: NSUUID().uuidString, username: "vitocorleone", profileImageUrl: "vito-corleone", fullName: "Vito Corleone", bio: "I'll make you an offer you can't refuse", email: "vitocorleone@mobmail.com"),
        .init(id: NSUUID().uuidString, username: "sonnycorleone", profileImageUrl: "sonny-corleone", fullName: "Sonny Corleone", bio: "Bada bing and it's all over your f suit", email: "sonnycorleone@mobmail.com"),
        .init(id: NSUUID().uuidString, username: "michaelcorleone", profileImageUrl: "michael-corleone", fullName: "Michael Corleone", bio: "Just when I thought I was out...", email: "vitocorleone@mobmail.com"),
        .init(id: NSUUID().uuidString, username: "don_barzini", profileImageUrl: "don-barzini", fullName: "Don Barzini", bio: "", email: "donbarzini@mobmail.com"),
        .init(id: NSUUID().uuidString, username: "luca_brasi", profileImageUrl: "luca-brasi", fullName: "Luca Brasi", bio: "Sleeping with the fishes", email: "lucabrasi@mobmail.com"),
    ]
}
