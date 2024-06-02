//
//  AuthService.swift
//  Instagram
//
//  Created by Mario Ban on 14.02.2024..
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import AuthenticationServices

class AuthService: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var isAnonymous = false
    static let shared = AuthService()
    
    private init() {
        Task { try await loadUserData()}
    }
    
    func enterAnonymousMode() {
        isAnonymous = true
        userSession = nil
        UserService.shared.currentUser = nil
        self.objectWillChange.send()
    }
    
    func exitAnonymousMode() {
        isAnonymous = false
        Task {
            try await loadUserData()
        }
    }
    
    @MainActor
    func login(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            try await loadUserData()
        } catch {
            print("Failed to login user \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func createUser(email: String, password: String, username: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            try await uploadUserData(uid: result.user.uid, username: username, email: email)
        } catch {
            print("Failed to register user \(error.localizedDescription)")
            throw error
        }
    }
    
    @MainActor
    func loadUserData() async throws {
        self.userSession = Auth.auth().currentUser
        guard let currentUid = userSession?.uid else { return }
        try await UserService.shared.fetchCurrentUser()
    }
    
    @MainActor
    func signout()  {
        try? Auth.auth().signOut()
        self.userSession = nil
        UserService.shared.currentUser = nil
    }
    
    private func uploadUserData(uid: String, username: String, email: String) async throws {
        let user = User(id: uid, username: username, email: email)
        UserService.shared.currentUser = user
        let encodedUser = try Firestore.Encoder().encode(user)
        try await FirebaseConstants.UsersCollection.document(user.id).setData(encodedUser)
    }
}
