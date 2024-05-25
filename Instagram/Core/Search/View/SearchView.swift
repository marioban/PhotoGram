import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @StateObject var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.filteredUsers) { user in  // Use filteredUsers here
                        NavigationLink(value: user) {
                            HStack {
                                CircularProfileImageView(user: user, size: .xSmall)
                                VStack(alignment: .leading) {
                                    Text(user.username)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color.primary)
                                    
                                    if let fullName = user.fullname {
                                        Text(fullName)
                                            .foregroundColor(Color.secondary)
                                    }
                                }
                                .font(.footnote)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .background(Color(UIColor.systemBackground))
                        }
                    }
                }
                .padding(.top, 8)
                .searchable(text: $searchText, prompt: "Search...")
                .onChange(of: searchText) { newValue in
                    viewModel.filterUsers(for: newValue) // Call filter method on text change
                }
            }
            .navigationDestination(for: User.self, destination: { user in
                ProfileView(user: user)  // Ensure ProfileView can be refreshed or observe user changes
            })
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


#Preview {
    SearchView()
}
