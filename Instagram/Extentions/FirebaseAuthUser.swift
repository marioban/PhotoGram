//
//  FirebaseAuthUser.swift
//  Instagram
//
//  Created by Mario Ban on 01.06.2024..
//

import Foundation
import Firebase

extension FirebaseAuth.User {
    func toUser() -> User {
        return User(id: self.uid, username: "Username", email: self.email ?? "No Email")
    }
}
