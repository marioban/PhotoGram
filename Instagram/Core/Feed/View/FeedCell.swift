import SwiftUI
import FirebaseFirestoreInternal
import UIKit
import Kingfisher
import Photos

struct FeedCell: View {
    @ObservedObject var viewModel: FeedCellViewModel
    @State private var showComments = false
    @State private var showingDownloadAlert = false
    @State private var downloadAlertMessage = ""
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            UserInfoView(user: viewModel.post.user)
                .padding([.horizontal, .top], 5)
            
            PostImageView(imageUrl: viewModel.post.imageUrl)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(radius: 5)
                .padding(.horizontal, 5)
            
            ActionButtonsView(didLike: viewModel.post.didLike ?? false, handleLikeTapped: handleLikeTapped, showComments: $showComments, imageUrl: viewModel.post.imageUrl, downloadImage: downloadImage)
                .padding(.horizontal, 5)
            
            PostLikesView(likes: viewModel.post.likes)
                .padding(.horizontal, 10)
            
            PostCaptionView(post: viewModel.post)
                .padding([.horizontal, .bottom], 10)
            
            PostTimeStampView(timeStamp: viewModel.post.timeStamp)
                .padding([.horizontal, .bottom], 10)
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 2)
        .padding(.horizontal,5) 
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .sheet(isPresented: $showComments) {
            CommentsView(post: viewModel.post)
        }
        .alert(isPresented: $showingDownloadAlert) {
            Alert(title: Text("Download Complete"), message: Text(downloadAlertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func handleLikeTapped() {
        Task {
            if viewModel.post.didLike ?? false {
                try await viewModel.unlike()
            } else {
                try await viewModel.like()
            }
        }
    }
    
    private func downloadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            DispatchQueue.main.async {
                downloadAlertMessage = "Image has been saved to your Photos. Open the Photos app to view it."
                showingDownloadAlert = true
            }
        }
        task.resume()
    }
}

struct UserInfoView: View {
    var user: User?
    var body: some View {
        HStack {
            if let user = user {
                CircularProfileImageView(user: user, size: .medium) // Consider increasing the size for visual impact
                Text(user.username)
                    .font(.headline) // Upgraded from .footnote to .headline for better visibility
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            Spacer()
        }
    }
}

struct PostImageView: View {
    var imageUrl: String

    var body: some View {
        Group {
            if let url = URL(string: imageUrl), !imageUrl.isEmpty {
                KFImage(url)
                    .resizable()
                    .scaledToFill()
                    .frame(minHeight: 200, maxHeight: 350)
                    .clipped()
            } else {
                Color.gray.frame(minHeight: 200, maxHeight: 300)
            }
        }
        .cornerRadius(10)
    }
}


struct ActionButtonsView: View {
    var didLike: Bool
    var handleLikeTapped: () -> Void
    var showComments: Binding<Bool>
    var imageUrl: String
    var downloadImage: (String) -> Void
    
    var body: some View {
        HStack {
            Button(action: handleLikeTapped) {
                Image(systemName: didLike ? "heart.fill" : "heart")
                    .imageScale(.large)
                    .foregroundColor(didLike ? .red : .gray) // Changed the default color to gray for a more neutral look
            }
            
            Button(action: { showComments.wrappedValue.toggle() }) {
                Image(systemName: "bubble.right")
                    .imageScale(.large)
                    .foregroundColor(.gray) // Consistent color scheme
            }
            
            Button(action: { downloadImage(imageUrl) }) {
                Image(systemName: "arrow.down.to.line")
                    .imageScale(.large)
                    .foregroundColor(.gray) // Consistent color scheme
            }
            
            Spacer()
        }
        .buttonStyle(PlainButtonStyle()) // Adding a button style for better touch interaction
        .padding(.vertical, 5)
    }
}

struct PostLikesView: View {
    var likes: Int
    var body: some View {
        if likes > 0 {
            Text("\(likes) likes")
                .font(.subheadline) // Adjusted for a subtler appearance
                .fontWeight(.medium)
                .foregroundColor(.black)
        }
    }
}

struct PostCaptionView: View {
    var post: Post
    var body: some View {
        HStack {
            Text("\(post.user?.username ?? "unknown"):")
                .fontWeight(.bold)
                .foregroundColor(.primary)
            Text(post.caption ?? "")
                .foregroundColor(.secondary)
        }
        .font(.footnote) // Kept the smaller font size for the caption to maintain content hierarchy
    }
}

struct PostTimeStampView: View {
    var timeStamp: Timestamp
    var body: some View {
        Text(timeStamp.timestampString())
            .font(.caption) // Smaller and more subtle font size for timestamp
            .foregroundColor(.gray) // Color adjusted to make it less prominent
    }
}

#Preview {
    FeedCell(viewModel: FeedCellViewModel(post: Post.MOCK_POSTS[0]))
}
