import SwiftUI

struct FeedView: View {
    @EnvironmentObject var authService: AuthService
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
                .padding(.top, 8)
            }
            .refreshable {
                await viewModel.loadMorePosts()
            }
            .onAppear {
                if authService.isAnonymous {
                    Task {await viewModel.loadMorePosts()}
                }
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
                
                if authService.isAnonymous {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            authService.exitAnonymousMode()
                        }) {
                            Image(systemName: "door.left.hand.open")
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
