//
//  UserService.swift
//  Instagram
//
//  Created by Mario Ban on 15.02.2024..
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct UserService {
    
    @MainActor
    static func fetchAllUsers() async throws -> [User]{
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        let documents = snapshot.documents
        return snapshot.documents.compactMap({ try? $0.data(as: User.self)})
    }
    
}
