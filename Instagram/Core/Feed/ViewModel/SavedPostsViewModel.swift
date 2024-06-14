//
//  SavedPostsViewModel.swift
//  Instagram
//
//  Created by Mario Ban on 09.06.2024..
//

import Foundation
import RealmSwift

class SavedPostsViewModel: ObservableObject {
    @Published var savedPosts: [Post] = []

    init() {
        loadSavedPosts()
    }

    func loadSavedPosts() {
        do {
            let realm = try Realm()
            let results = realm.objects(SavedPost.self)
            results.forEach { savedPost in
                print("Post ID: \(savedPost.id), Caption: \(savedPost.caption ?? "N/A")")
            }
            self.savedPosts = results.map { Post(from: $0) }
            print("Currently saved posts: \(self.savedPosts.map { $0.id })")
        } catch {
            print("Error loading posts from Realm: \(error)")
        }
    }

}
