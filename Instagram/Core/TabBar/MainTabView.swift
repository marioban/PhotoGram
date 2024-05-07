import SwiftUI

struct MainTabView: View {
    let user: User
    @State private var selectedIndex = 0

    var body: some View {
        TabView(selection: $selectedIndex) {
            FeedView()
                .onAppear {
                    selectedIndex = 0
                }
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            SearchView()
                .onAppear {
                    selectedIndex = 1
                }
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(1)

            UploadPostView(tabIndex: $selectedIndex)
                .onAppear {
                    selectedIndex = 2
                }
                .tabItem {
                    Label("Post", systemImage: "plus.square")
                }
                .tag(2)

            Text("Notifications") // Placeholder view
                .onAppear {
                    selectedIndex = 3
                }
                .tabItem {
                    Label("Notifications", systemImage: "heart")
                }
                .tag(3)

            CurrentUserProfileView(user: user)
                .onAppear {
                    selectedIndex = 4
                }
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(4)
        }
        .accentColor(Color.primary) // Use primary to automatically adapt to theme changes
    }
}

#Preview {
    MainTabView(user: User.MOCK_USERS[0])
}
