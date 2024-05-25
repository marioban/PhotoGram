//
//  Constants.swift
//  Instagram
//
//  Created by Mario Ban on 24.05.2024..
//

import Foundation
import Firebase

struct FirebaseConstants {
    static let Root = Firestore.firestore()
    static let UsersCollection = Root.collection("users")
    static let PostCollection = Root.collection("posts")
    static let FollowingCollection = Root.collection("following")
    static let FollowersCollection = Root.collection("followers")
}
