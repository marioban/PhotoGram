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
    
    func googleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            if let error = error {
                print("Error doing Google Sign-In, \(error)")
                return
            }
            
            guard let signInResult = signInResult else {
                print("Sign-In result is nil")
                return
            }
            
            let user = signInResult.user
            guard let idToken = user.idToken?.tokenString else {
                print("Error during Google Sign-In authentication")
                return
            }
            
            let accessToken = user.accessToken.tokenString
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            // Authenticate with Firebase
            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                    return
                }
                
                guard let self = self, let user = authResult?.user else {
                    print("Auth result or user is nil")
                    return
                }
                
                // Check if the user data exists in Firestore
                self.checkAndSetupUser(uid: user.uid, email: user.email)
            }
        }
    }
    
    func githubSignIn() {
        print("Starting GitHub sign-in process.")
        let provider = OAuthProvider(providerID: "github.com")
        
        provider.getCredentialWith(nil) { credential, error in
            if let error = error {
                print("Error getting GitHub credentials: \(error.localizedDescription)")
                return
            }
            
            guard let credential = credential else {
                print("No credential found.")
                return
            }
            
            print("GitHub credential obtained.")
            
            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                if let e = error {
                    print("Error signing in with GitHub credential: \(e.localizedDescription)")
                    return
                }
                
                guard let self = self, let user = authResult?.user else {
                    print("Auth result or user is nil")
                    return
                }
                
                print("User signed in successfully. UID: \(user.uid)")
                
                // Check if the user data exists in Firestore
                self.checkAndSetupUser(uid: user.uid, email: user.email)
            }
        }
    }

    
    private func checkAndSetupUser(uid: String, email: String?) {
        let userRef = FirebaseConstants.UsersCollection.document(uid)
        
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                print("User already exists, logging in.")
                Task {
                    try await self.loadUserData()
                }
            } else {
                print("User does not exist, creating new user.")
                let username = email?.components(separatedBy: "@").first ?? "Unknown"
                Task {
                    do {
                        try await self.uploadUserData(uid: uid, username: username, email: email ?? "unknown@example.com")
                        try await self.loadUserData()
                    } catch {
                        print("Error uploading user data: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func googleSignOut() {
        GIDSignIn.sharedInstance.signOut()
    }
    
    func githubSignOut() {
        try? Auth.auth().signOut()
        self.userSession = nil
        UserService.shared.currentUser = nil
    }
    
}
