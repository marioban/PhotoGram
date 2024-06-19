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
    private let repository: RealmRepository

    init(post: Post, repository: RealmRepository = RealmRepositoryImpl()) {
        self.post = post
        self.repository = repository
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

    func checkIfPostIsSaved() async throws {
        self.post.didSave = repository.exists(SavedPost.self, id: post.id)
    }

    func toggleSave() async {
        let currentIsSaved = post.didSave
        post.didSave?.toggle()

        do {
            if post.didSave ?? false {
                print("Post saved")
                try repository.save(object: SavedPost(from: post))
            } else {
                print("Post unsaved")
                try repository.deleteById(SavedPost.self, id: post.id)
            }
            objectWillChange.send()
        } catch {
            print("Failed to update save status: \(error)")
            post.didSave = currentIsSaved
        }
    }
}
