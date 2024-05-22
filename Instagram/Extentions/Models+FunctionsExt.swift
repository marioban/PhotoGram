//
//  Models+FunctionsExt.swift
//  Instagram
//
//  Created by Mario Ban on 13.05.2024..
//

import SwiftUI
import MapKit
import UIKit
import Firebase
import FirebaseStorage

struct UserService {
    
    private static let usersCollection = Firestore.firestore().collection("users")
    
    static func fetchuser(withUid uid: String) async throws -> User {
        let snapshot = try await usersCollection.document(uid).getDocument()
        return try snapshot.data(as: User.self)
    }
    
    @MainActor
    static func fetchAllUsers() async throws -> [User]{
        let snapshot = try await usersCollection.getDocuments()
        let documents = snapshot.documents
        return snapshot.documents.compactMap({ try? $0.data(as: User.self)})
    }
    
}

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No update action needed
    }
}

struct IdentifiableAnnotation: Identifiable {
    let id: UUID
    var annotation: MKPointAnnotation
    
    init(annotation: MKPointAnnotation) {
        self.id = UUID()
        self.annotation = annotation
    }
}


enum ImageType {
    case system(name: String)
    case asset(name: String)
}


struct ImageUploader {
    static func uploadImage(image: UIImage) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return nil }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
        do {
            let _ = try await ref.putDataAsync(imageData)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            print("DEBUG: Failed to upload image with error \(error.localizedDescription)")
            return nil
        }
    }
}

struct PostService {
    private static let postsCollection = Firestore.firestore().collection("posts")
    
    static func fetchFeedPosts() async throws -> [Post] {
        let snapshot = try await postsCollection.getDocuments()
        var posts = try snapshot.documents.compactMap({try $0.data(as: Post.self)})
        
        for i in 0 ..< posts.count {
            let post = posts[i]
            let ownerUid = post.ownerUid ?? ""
            let postUser = try await UserService.fetchuser(withUid: ownerUid)
            posts[i].user = postUser
        }
        
        return posts
    }
    
    static func fetchUserPosts(uid: String) async throws -> [Post] {
        let snapshot = try await postsCollection.whereField("ownerUid", isEqualTo: uid).getDocuments()
        return try snapshot.documents.compactMap({try $0.data(as: Post.self)})
    }
}
