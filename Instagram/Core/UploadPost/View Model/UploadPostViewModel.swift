//
//  UploadPostViewModel.swift
//  Instagram
//
//  Created by Mario Ban on 14.02.2024..
//

import Foundation
import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestoreInternal

@MainActor
class UploadPostViewModel: ObservableObject {
    
    @Published var selectedImage: PhotosPickerItem? {
        didSet { Task { await loadImage(fromItem: selectedImage) }}
    }
    
    @Published var postImage: Image?
    @Published var location: String?
    @Published var locationDetail: LocationDetail?
    @Published var isUploading = false
    @Published var uploadError: String?
    private var uiImage: UIImage?

    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }
        do {
            guard let data = try await item.loadTransferable(type: Data.self) else { return }
            guard let uiImage = UIImage(data: data) else { return }
            self.postImage = Image(uiImage: uiImage)
            self.uiImage = uiImage
        } catch {
            print("Failed to load image: \(error.localizedDescription)")
            uploadError = "There was an error loading the image."
        }
    }
    
    func uploadPost(caption: String) async throws {
        guard !isUploading else { return }
        isUploading = true
        defer { isUploading = false }
        
        do {
            guard let uid = Auth.auth().currentUser?.uid else { throw NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey : "User not authenticated"]) }
            guard let uiImage = uiImage else { throw NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey : "Image not selected"]) }
            
            let postRef = Firestore.firestore().collection("posts").document()
            guard let imageUrl = try await ImageUploader.uploadImage(image: uiImage) else { throw NSError(domain: "UploadError", code: 0, userInfo: [NSLocalizedDescriptionKey : "Failed to upload image"]) }
            
            let post = Post(id: postRef.documentID, ownerUid: uid, caption: caption, likes: 0, imageUrl: imageUrl, timeStamp: Timestamp(), locationDetail: locationDetail)
            guard let encodedPost = try? Firestore.Encoder().encode(post) else { throw NSError(domain: "EncodingError", code: 0, userInfo: [NSLocalizedDescriptionKey : "Failed to encode post"]) }
            
            try await postRef.setData(encodedPost)
        } catch {
            print("Upload failed: \(error.localizedDescription)")
            uploadError = "Failed to upload post: \(error.localizedDescription)"
            throw error
        }
    }
}
