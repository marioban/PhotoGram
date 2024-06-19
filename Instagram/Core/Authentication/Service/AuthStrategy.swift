//
//  AuthStrategy.swift
//  Instagram
//
//  Created by Mario Ban on 19.06.2024..
//

import Foundation
import FirebaseAuth

protocol AuthStrategy {
    func authenticate(email: String?, password: String?) async throws -> FirebaseAuth.User
}

enum AuthError: Error {
    case missingCredentials
}

class EmailPasswordAuthStrategy: AuthStrategy {
    func authenticate(email: String?, password: String?) async throws -> FirebaseAuth.User {
        guard let email = email, let password = password else {
            throw AuthError.missingCredentials
        }
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user
    }
}

class GoogleAuthStrategy: AuthStrategy {
    func authenticate(email: String?, password: String?) async throws -> FirebaseAuth.User {
        // Implement Google Sign-In authentication here.
        // Note: This is a placeholder as the actual implementation would require additional setup.
        throw AuthError.missingCredentials // Replace with actual implementation
    }
}
