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

class UserService {
    
    @Published var currentUser: User?
    
    static let shared = UserService()
    
    
    //MARK: fetching
    @MainActor
    func fetchCurrentUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        self.currentUser = try await FirebaseConstants.UsersCollection.document(uid).getDocument(as: User.self)
    }
    
    static func fetchUser(withUid uid: String) async throws -> User {
        let snapshot = try await FirebaseConstants.UsersCollection.document(uid).getDocument()
        return try snapshot.data(as: User.self)
    }
    
    static func fetchAllUsers() async throws -> [User]{
        let snapshot = try await FirebaseConstants.UsersCollection.getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: User.self)})
    }
    
    
    //MARK: following
    static func follow(uid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = try await FirebaseConstants.FollowingCollection.document(currentUid).collection("user-following").document(uid).setData([:])
        async let _ = try await FirebaseConstants.FollowersCollection.document(uid).collection("user-followers").document(currentUid).setData([:])
    }
    
    static func unfollow(uid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = try await FirebaseConstants.FollowingCollection.document(currentUid).collection("user-following").document(uid).delete()
        async let _ = try await FirebaseConstants.FollowersCollection.document(uid).collection("user-followers").document(currentUid).delete()
    }
    
    static func checkIfUserIsFollowed(uid: String) async throws -> Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
        
        let snapshot = try await FirebaseConstants.FollowingCollection.document(currentUid).collection("user-following").document(uid).getDocument()
        
        return snapshot.exists
    }
    
    //MARK: user stats
    static func fetchUserStats(uid: String) async throws -> UserStats {
        async let followingCount = FirebaseConstants.FollowingCollection.document(uid).collection("user-following").getDocuments().count
        
        async let followersCount = FirebaseConstants.FollowersCollection.document(uid).collection("user-followers").getDocuments().count
        
        async let postCount = FirebaseConstants.PostCollection.whereField("ownerUid", isEqualTo: uid).getDocuments().count
        
        print("DEBUG: Did call fetch user stats...")
        return try await .init(followingCount: followingCount, followersCount: followersCount, postCount: postCount)
    }
    
    //MARK:
    
    static func fetchUsers(forConfig config: UserList) async throws -> [User] {
        switch config {
        case .followers(let uid):
            return try await fetchFollowers(uid: uid)
        case .following(let uid):
            return try await fetchFollowing(uid: uid)
        case .likes(let postId):
            return try await fetchLikes(postId: postId)
        case .explore:
            return try await fetchAllUsers()
        }
    }
    
    private static func fetchFollowers(uid: String) async throws -> [User] {
        let snapshot = try await FirebaseConstants.FollowersCollection.document(uid).collection("user-followers").getDocuments()
        
        return try await fetchUsers(snapshot)
    }
    
    private static func fetchFollowing(uid: String) async throws -> [User] {
        let snapshot = try await FirebaseConstants.FollowingCollection.document(uid).collection("user-following").getDocuments()
        
        return try await fetchUsers(snapshot)
    }
    
    private static func fetchLikes(postId: String) async throws -> [User] {
        return []
    }
    
    private static func fetchUsers(_ snapshot: QuerySnapshot) async throws -> [User] {
        var users = [User]()
        for doc in snapshot.documents{
            users.append(try await fetchUser(withUid: doc.documentID))
        }
        
        return users
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
    
    //MARK: Fetch
    static func fetchFeedPosts() async throws -> [Post] {
        let snapshot = try await FirebaseConstants.PostCollection.order(by: "timeStamp", descending: true).getDocuments()
        var posts = try snapshot.documents.compactMap({try $0.data(as: Post.self)})
        
        for i in 0..<posts.count {
            let post = posts[i]
            let ownerUid = post.ownerUid
            if let postUser = try? await UserService.fetchUser(withUid: ownerUid) {
                posts[i].user = postUser
            } else {
                print("Failed to fetch user for post \(i)")
            }
        }
        
        return posts
    }
    
    
    static func fetchUserPosts(uid: String) async throws -> [Post] {
        let snapshot = try await FirebaseConstants.PostCollection.whereField("ownerUid", isEqualTo: uid).getDocuments()
        return try snapshot.documents.compactMap { try $0.data(as: Post.self) }
    }
    
    //MARK: Likes
    
    static func likePost(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        async let _ = try await FirebaseConstants.PostCollection.document(post.id).collection("post-likes").document(uid).setData([:])
        async let _ = try await FirebaseConstants.PostCollection.document(post.id).updateData(["likes" : post.likes + 1])
        async let _ = FirebaseConstants.UsersCollection.document(uid).collection("user-likes").document(post.id).setData([:])
    }
    
    static func unlikePost(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = try await FirebaseConstants.PostCollection.document(post.id).collection("post-likes").document(uid).delete()
        async let _ = try await FirebaseConstants.PostCollection.document(post.id).updateData(["likes" : post.likes - 1])
        async let _ = FirebaseConstants.UsersCollection.document(uid).collection("user-likes").document(post.id).delete()
    }
    
    static func checkIfUserLikedPost(_ post: Post) async throws -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        
        let snapshot = try await FirebaseConstants.UsersCollection.document(uid).collection("user-likes").document(post.id).getDocument()
        return snapshot.exists
    }
    
    static func fetchPost(_ postId: String) async throws -> Post {
        return try await FirebaseConstants.PostCollection.document(postId).getDocument(as: Post.self)
    }
}


struct CommentService {
    
    let postId: String
    
    func uploadComment(_ comment: Comment) async throws {
        guard let commentData = try? Firestore.Encoder().encode(comment) else { return }
        
        try await FirebaseConstants.PostCollection.document(postId).collection("post-comments").addDocument(data: commentData)
    }
    
    func fetchComments() async throws -> [Comment] {
        let snapshot = try await FirebaseConstants.PostCollection.document(postId).collection("post-comments").order(by: "timestamp", descending: false).getDocuments()
        
        return snapshot.documents.compactMap({ try? $0.data(as: Comment.self)})
    }
}


class NotificationService {
    
    func fetchNotifications() async throws -> [Notification] {
        guard let currentUid = Auth.auth().currentUser?.uid else { return []}
        
        let snapshot = try await FirebaseConstants.UserNotificationCollection(uid: currentUid).order(by: "timestamp", descending: true).getDocuments()
        
        return snapshot.documents.compactMap({ try? $0.data(as: Notification.self)})
    }
    
    func uploadNotification(toUid uid: String, type: NotificationType, post: Post? = nil) {
        guard let currentUid = Auth.auth().currentUser?.uid, uid != currentUid else { return }
        let ref = FirebaseConstants.UserNotificationCollection(uid: uid).document()
        
        let notification = Notification(id: ref.documentID, postId: post?.id, timestamp: Timestamp(), notificationSenderUid: currentUid, type: type)
        
        guard let notificationData = try? Firestore.Encoder().encode(notification) else { return }
        ref.setData(notificationData)
    }
    
    func deleteNotification(toUid uid: String, type: NotificationType, post: Post? = nil) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let snapshot = try await FirebaseConstants.UserNotificationCollection(uid: uid).whereField("notificationSenderUid", isEqualTo: currentUid)
            .getDocuments()
        
        let notifications = snapshot.documents.compactMap({try? $0.data(as: Notification.self)})
        
        let filterByType = notifications.filter({ $0.type == type}) //gets all notifications by type
        guard let notificationToDelete = filterByType.first(where: {$0.postId == post?.id}) else {return} //gets notifications for that post
        
        try await FirebaseConstants.UserNotificationCollection(uid: uid).document(notificationToDelete.id).delete()
    }
}

class NotificationManager {
    private let service = NotificationService()
    static let shared = NotificationManager()
    
    func uploadLikeNotification(toUid uid: String, post: Post) {
        service.uploadNotification(toUid: uid, type: .like, post: post)
    }
    
    func uploadCommentNotification(toUid uid: String, post: Post) {
        service.uploadNotification(toUid: uid, type: .comment, post: post)
    }
    
    func uploadFollowNotification(toUid uid: String) {
        service.uploadNotification(toUid: uid, type: .follow)
    }
    
    func deleteLikeNotification(notificationOwnerUid: String, post: Post) async {
        do {
            try await service.deleteNotification(toUid: notificationOwnerUid, type: .like, post: post)
        } catch {
            print("DEBUG: Failed to delete")
        }
    }
    
}
