import SwiftUI

struct FeedView: View {
    @EnvironmentObject var authService: AuthService
    @StateObject var viewModel = FeedViewModel()
    @State private var showComments = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 32) {
                    ForEach(viewModel.posts) { post in
                        FeedCell(post: post)
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
                    ToolbarItem(placement: .navigationBarLeading) {
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
