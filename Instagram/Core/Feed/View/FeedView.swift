import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    @State private var showComments = false

    var body: some View {
        NavigationStack {
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
                    Button(action: {
                        print("Direct message view opened")
                    }) {
                        Image(systemName: "message")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .foregroundColor(Color.primary)
                }
            }
        }
    }
}


#Preview {
    FeedView()
}
