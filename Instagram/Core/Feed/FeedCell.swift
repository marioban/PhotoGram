import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No update action needed
    }
}


struct FeedCell: View {
    let post: Post
    @State private var isLiked = false
    @State private var showingShareSheet = false
    @State private var itemsToShare = [Any]()
    
    var body: some View {
        VStack {
            // Image + Username
            HStack {
                if let user = post.user {
                    Image(user.profileImageUrl ?? "default_profile")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    Text(user.username)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.primary)
                }
                Spacer()
            }
            .padding(.leading, 8)
            
            // Post image
            Image(post.imageUrl)
                .resizable()
                .scaledToFill()
                .frame(height: 400)
                .clipShape(Rectangle())
            
            // Action buttons
            HStack(spacing: 16) {
                Button(action: {
                    isLiked.toggle()
                }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .imageScale(.large)
                        .foregroundColor(isLiked ? .red : .primary)
                }
                
                Button(action: {
                    print("Comment on post")
                }) {
                    Image(systemName: "bubble.right")
                        .imageScale(.large)
                        .foregroundColor(Color.primary)
                }
                
                Button(action: sharePost) {
                    Image(systemName: "paperplane")
                        .imageScale(.large)
                        .foregroundColor(Color.primary)
                }
                
                Spacer()
            }
            .padding(.leading, 8)
            .padding(.top, 4)
            
            // Likes
            Text("\(post.likes) likes")
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(Color.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)
                .padding(.top, 1)
            
            // Caption
            HStack {
                Text("\(post.user?.username ?? "unknown")").fontWeight(.semibold) +
                Text(" " + (post.caption ?? ""))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 8)
            .padding(.top, 1)
            .font(.footnote)
            
            // Timestamp
            Text("6h ago")
                .font(.footnote)
                .foregroundColor(Color.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)
                .padding(.top, 1)
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(items: itemsToShare)
        }
    }
    
    private func sharePost() {
        // Customize this array with actual data you want to share
        itemsToShare = ["Check out this post: \(post.caption ?? "Interesting post!")"]
        showingShareSheet = true
    }
}

#Preview {
    FeedCell(post: Post.MOCK_POSTS[0])
}
