//
//  EditProfileViewModel.swift
//  Instagram
//
//  Created by Mario Ban on 06.03.2024..
//

import SwiftUI
import PhotosUI
import FirebaseCore

@MainActor
class EditProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var selectedImage: PhotosPickerItem? {
        didSet { Task {await loadImage(fromItem: selectedImage)}}
    }
    
    @Published var profileImage: Image?
    @Published var name = ""
    @Published var bio = ""
    
    init(user: User) {
        self.user = user
    }
    
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.profileImage = Image(uiImage: uiImage)
    }
    
    func updateUserData() async throws {
        // update profile image if changed
        
        // update name if changed
        if name.isEmpty && user.fullName != name {
            
        }
        
        //update bio if changed
    }
}
