import SwiftUI

struct FeedView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 32) {
                    ForEach(Post.MOCK_POSTS) { post in
                        FeedCell(post: post)
                    }
                }
                .padding(.top, 8)
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
                        // Assume this would open the direct messages or similar functionality
                        print("Direct message view opened")
                    }) {
                        Image(systemName: "message")
                            .resizable()
                            .frame(width: 25, height: 25)  // Correctly sizing the icon
                    }
                    .foregroundColor(Color.primary)  // Ensures icon color adapts to light/dark mode
                }
            }
        }
    }
}

#Preview {
    FeedView()
}
