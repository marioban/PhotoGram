import SwiftUI
import FirebaseAnalytics
import FirebasePerformance

//metrics
//firebase analytics and firebase performance
//tracking screen view - how often the feed is accessed
//feed load performance - track how long it takes to load posts from the feed.

struct FeedView: View {
    @EnvironmentObject var authService: AuthService
    @StateObject var viewModel = FeedViewModel()
    @State private var showComments = false
    @State private var feedLoadTrace: Trace?
    
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
                // Log the screen view event when FeedView appears
                Analytics.logEvent(AnalyticsEventScreenView, parameters: [
                    AnalyticsParameterScreenName: "FeedView",
                    AnalyticsParameterScreenClass: "FeedView"
                ])
                
                // Start tracking feed loading performance
                feedLoadTrace = Performance.startTrace(name: "feed_load_time")
                
                if authService.isAnonymous {
                    Task {await viewModel.loadMorePosts()}
                    feedLoadTrace?.stop()  // Stop the trace after posts are loaded
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
