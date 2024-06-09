//
//  SavedFeedView.swift
//  Instagram
//
//  Created by Mario Ban on 09.06.2024..
//

import SwiftUI

struct SavedFeedView: View {
    @EnvironmentObject var viewModel: SavedPostsViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 32) {
                    ForEach(viewModel.savedPosts, id: \.id) { post in
                        FeedCell(viewModel: FeedCellViewModel(post: post))
                    }
                }
                .padding(.top, 8)
                .padding(.horizontal, 5)
            }
            .navigationTitle("Saved Posts")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                viewModel.loadSavedPosts()
            }
        }
    }
}

#Preview {
    SavedFeedView()
}
