//
//  FeedCellViewModel.swift
//  Instagram
//
//  Created by Mario Ban on 22.05.2024..
//

import Foundation
import FirebaseAuth
import FirebaseFirestoreInternal
import RealmSwift

@MainActor
class FeedCellViewModel: ObservableObject {
    @Published var post: Post
    
    init(post: Post) {
        self.post = post
        Task {
            try await checkIfUserLikedPost()
            try await checkIfPostIsSaved()
        }
    }
    
    func like() async throws {
        do {
            let postCopy = post
            post.didLike = true
            post.likes += 1
            try await PostService.likePost(postCopy)
            NotificationManager.shared.uploadLikeNotification(toUid: post.ownerUid, post: post)
        } catch {
            post.didLike = false
            post.likes -= 1
        }
    }
    
    func unlike() async throws {
        do {
            let postCopy = post
            post.didLike = false
            post.likes -= 1
            try await PostService.unlikePost(postCopy)
            await NotificationManager.shared.deleteLikeNotification(notificationOwnerUid: post.ownerUid, post: post)
        } catch {
            post.didLike = true
            post.likes += 1
        }

    }
    
    func checkIfUserLikedPost() async throws {
        guard let uid = Auth.auth().currentUser?.uid, !post.id.isEmpty else {
            throw NSError(domain: "AppError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid user ID or post ID"])
        }

        let postRef = Firestore.firestore().collection("posts").document(post.id)

        do {
            let docSnapshot = try await postRef.getDocument()
            if docSnapshot.exists {
                if let likesArray = docSnapshot.data()?["likes"] as? [String] {
                    // Check if the user's ID is in the array of likes
                    self.post.didLike = likesArray.contains(uid)
                } else {
                    self.post.didLike = false
                }
            } else {
                // Document does not exist
                self.post.didLike = false
            }
        } catch let error {
            print("Failed to check if user liked post: \(error)")
            throw error
        }
    }

    func checkIfPostIsSaved() async throws{
        let realm = try await Realm()
        if let _ = realm.object(ofType: SavedPost.self, forPrimaryKey: post.id) {
            post.didSave = true
        } else {
            post.didSave = false
        }
    }

    
    func toggleSave() async {
        let currentIsSaved = post.didSave
        post.didSave?.toggle()

        do {
            if post.didSave ?? false {
                print("Post saved")
                try await savePostToRealm(post: post)
            } else {
                print("Post unsaved")
                try await removePostFromRealm(postId: post.id)
            }
            objectWillChange.send()
        } catch {
            print("Failed to update save status: \(error)")
            post.didSave = currentIsSaved
        }
    }

    // Asynchronous function to save a post to Realm
    func savePostToRealm(post: Post) async throws {
        let realm = try await Realm()
        print("Attempting to save post with ID: \(post.id)")
        if realm.object(ofType: SavedPost.self, forPrimaryKey: post.id) == nil {
            let savedPost = SavedPost(from: post)
            try realm.write {
                realm.add(savedPost)
                print("Post saved with ID: \(savedPost.id)")
            }
        } else {
            print("Post with ID \(post.id) already exists. Not saving again.")
        }
    }


    // Asynchronous function to remove a post from Realm
    func removePostFromRealm(postId: String) async throws {
        let realm = try await Realm()
        print("Attempting to delete post with ID: \(postId)")
        guard let savedPost = realm.object(ofType: SavedPost.self, forPrimaryKey: postId) else {
            print("No post found with ID \(postId) to delete.")
            return
        }
        try realm.write {
            realm.delete(savedPost)
            print("Post deleted from Realm.")
        }
    }
    
}
