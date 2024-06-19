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

@MainActor
class UploadPostViewModel: ObservableObject {
    
    struct LocationDetail {
        var coordinate: CLLocationCoordinate2D
        var streetName: String
        var city: String
        var establishmentName: String
    }
    
    @Published var selectedImage: PhotosPickerItem? {
        didSet { Task {await loadImage(fromItem: selectedImage)}}
    }
    
    @Published var postImage: Image?
    @Published var location: String?
    @Published var locationDetail: LocationDetail?
    private var uiImage: UIImage?

    
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.postImage = Image(uiImage: uiImage)
        self.uiImage = uiImage
    }
    
    func uploadPost(caption: String) async throws { 
        guard let uid = Auth.auth().currentUser?.uid else { return  }
        guard let uiImage = uiImage else { return }
        
        let postRef = Firestore.firestore().collection("posts").document()
        guard let imageUrl = try await ImageUploader.uploadImage(image: uiImage) else { return }
        let post = Post(id: postRef.documentID, ownerUid: uid, caption: caption, likes: 0, imageUrl: imageUrl, timeStamp: Timestamp())
        guard let encodedPost = try? Firestore.Encoder().encode(post) else { return }
        
        try await postRef.setData(encodedPost)
        try await PostService.fetchFeedPosts() // does not work
        try await PostService.fetchUserPosts(uid: uid)
    }
}
