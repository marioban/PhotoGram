//
//  UserList.swift
//  Instagram
//
//  Created by Mario Ban on 24.05.2024..
//

import Foundation

enum UserList: Hashable {
    case followers(uid: String)
    case following(uid: String)
    case likes(postId: String)
    case explore
    
    var navigationTitle: String {
        switch self {
        case .followers:
            return "Followers"
        case .following:
            return "Following"
        case .likes:
            return "Likes"
        case .explore:
            return "Explore"
        }
    }
}
