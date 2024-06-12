import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    @State private var showComments = false
    @State private var navigateToSavedPosts = false
    
    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                VStack {
                    Spacer()
                    VStack {
                        Text("Loading posts...")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        LoadingAnimationView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("Feed")
                .navigationBarTitleDisplayMode(.inline)
            } else {
                ScrollView {
                    LazyVStack(spacing: 32) {
                        ForEach(viewModel.posts) { post in
                            FeedCell(viewModel: FeedCellViewModel(post: post))
                                .onAppear{
                                    if post == viewModel.posts.last {
                                        Task {
                                            await viewModel.loadMorePosts()
                                        }
                                    }
                                }
                        }
                    }
                    .padding(.top, 8)
                    .padding(.horizontal,5)
                }
                .refreshable {
                    await viewModel.loadMorePosts()
                }
                .navigationTitle("Feed")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Image("Instagram_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 32)
                    }
                    
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: SavedFeedView(), isActive: $navigateToSavedPosts) {
                            Button(action: {
                                navigateToSavedPosts = true
                            }) {
                                Image(systemName: "bookmark")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            }
                            .foregroundColor(Color.primary)
                        }
                    }
                    
                }
            }
        }
    }
}


#Preview {
    FeedView()
}
