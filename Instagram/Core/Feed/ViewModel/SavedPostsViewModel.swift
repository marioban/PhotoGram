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
    private let repository: RealmRepository

    init(repository: RealmRepository = RealmRepositoryImpl()) {
        self.repository = repository
        loadSavedPosts()
    }

    func loadSavedPosts() {
        if let results = repository.fetch(SavedPost.self) {
            results.forEach { savedPost in
                print("Post ID: \(savedPost.id), Caption: \(savedPost.caption ?? "N/A")")
            }
            self.savedPosts = results.map { Post(from: $0) }
            print("Currently saved posts: \(self.savedPosts.map { $0.id })")
        }
    }
}
