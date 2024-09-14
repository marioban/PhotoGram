import SwiftUI
import FirebaseAnalytics
import FirebasePerformance

//firebase analytics and firebase performance
//search screen views: monitor how often users access the search view.
//custom search trace: measure performance for searching users.
struct SearchView: View {
    @State private var searchText = ""
    @StateObject var viewModel = SearchViewModel()
    @State private var searchTrace: Trace?
    
    var body: some View {
        NavigationStack {
            UserListView(config: .explore, searchViewModel: viewModel)
                .navigationDestination(for: User.self, destination: { user in
                    ProfileView(user: user)
                })
                .navigationTitle("Explore")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    // Log screen view for Search
                    Analytics.logEvent(AnalyticsEventScreenView, parameters: [
                        AnalyticsParameterScreenName: "SearchView",
                        AnalyticsParameterScreenClass: "SearchView"
                    ])
                    
                    // Start tracking search performance
                    searchTrace = Performance.startTrace(name: "search_performance")
                }
                .onDisappear {
                    searchTrace?.stop()  // Stop the search performance trace
                }
        }
    }
}

#Preview {
    SearchView()
}
