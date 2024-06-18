import SwiftUI
import UIKit
import Kingfisher
import Photos

struct FeedCell: View {
    @ObservedObject var viewModel: FeedCellViewModel
    @State private var showComments = false
    @State private var showingDownloadAlert = false
    @State private var downloadAlertMessage = ""
    @State private var showMap = false
    @State private var selectedLocation: LocationDetail?
    @EnvironmentObject var authService: AuthService
    
    private var post: Post {
        return viewModel.post
    }
    
    private var didLike: Bool {
        return post.didLike ?? false
    }
    
    init(post: Post) {
        self.viewModel = FeedCellViewModel(post: post)
    }
    
    @State private var showComments = false
    @State private var showingDownloadAlert = false
    @State private var downloadAlertMessage = ""
    @State private var showLoginView = false
    
    var body: some View {
        VStack {
            // Image + Username
            HStack {
                if let user = post.user {
                    CircularProfileImageView(user: user, size: .xSmall)
                    Text(user.username)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.primary)
                }
                Spacer()
            }
            .padding(.leading, 8)
            
            // Post image
            KFImage(URL(string: post.imageUrl))
                .resizable()
                .scaledToFit()
                .frame(height: 400)
                .clipShape(Rectangle())
            
            // Action buttons
            HStack(spacing: 16) {
                Button(action: {
                    selectedLocation = locationDetail
                    showMap.toggle()
                }) {
                    Image(systemName: didLike ? "heart.fill" : "heart")
                        .imageScale(.large)
                        .foregroundColor(didLike ? .red : .primary)
                }
            }
            
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
            Text(post.timeStamp.timestampString())
                .font(.footnote)
                .foregroundColor(Color.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)
                .padding(.top, 1)
        }
        .sheet(isPresented: $showComments) {
            CommentsView(post: post)
                .presentationDragIndicator(.visible)
        }
        .alert(isPresented: $showingDownloadAlert) {
            Alert(title: Text("Download Complete"), message: Text(downloadAlertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func handleLikeTapped() {
        Task {
            if didLike {
                try await viewModel.unlike()
            } else {
                try await viewModel.like()
            }
        }
    }
    
    private func downloadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else { return }
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            DispatchQueue.main.async {
                self.downloadAlertMessage = "Image has been saved to your Photos. Open the Photos app to view it."
                self.showingDownloadAlert = true
            }
        }
        task.resume()
    }
    
    private func performActionOrLogin(_ action: @escaping () -> Void) {
        if authService.isAnonymous {
            showLoginView = true
        } else {
            action()
        }
    }
}

#Preview {
    FeedCell(post: Post.MOCK_POSTS[0])
}
