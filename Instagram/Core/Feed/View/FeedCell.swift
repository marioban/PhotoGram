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
    @State private var showMap = false
    @State private var selectedLocation: LocationDetail?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            UserInfoView(user: viewModel.post.user)
                .padding([.horizontal, .top], 5)
            
            PostImageView(imageUrl: viewModel.post.imageUrl)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(radius: 5)
            
            ActionButtonsView(didLike: viewModel.post.didLike ?? false, didSave: viewModel.post.didSave ?? false, handleLikeTapped: handleLikeTapped, handleSaveTapped: handleSaveTapped, showComments: $showComments, imageUrl: viewModel.post.imageUrl, downloadImage: downloadImage)
                .padding(.horizontal, 5)
            
            PostLikesView(likes: viewModel.post.likes)
                .padding(.horizontal, 10)
            
            PostCaptionView(post: viewModel.post)
                .padding(.horizontal, 10)
                .padding(.bottom, 3)
            
            if let locationDetail = viewModel.post.locationDetail {
                Button(action: {
                    selectedLocation = locationDetail
                    showMap.toggle()
                }) {
                    LocationDetailView(coordinate: locationDetail.coordinate, streetName: locationDetail.streetName, city: locationDetail.city, establishmentName: locationDetail.establishmentName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
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
                print("liked")
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
    
    var body: some View {
        Group {
            if let url = URL(string: imageUrl), !imageUrl.isEmpty {
                KFImage(url)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .cornerRadius(10)
                    .padding(.horizontal)
            } else {
                Color.gray.frame(height: 200)
            }
        }
    }
}

struct ActionButtonsView: View {
    var didLike: Bool
    var didSave: Bool
    var handleLikeTapped: () -> Void
    var handleSaveTapped: () -> Void
    var showComments: Binding<Bool>
    var imageUrl: String
    var downloadImage: (String) -> Void
    
    var body: some View {
        HStack {
            Button(action: handleLikeTapped) {
                Image(systemName: didLike ? "heart.fill" : "heart")
                    .imageScale(.large)
                    .foregroundColor(didLike ? .red : .gray)
            }
            .accessibility(identifier: "likeButton")
            
            Button(action: { showComments.wrappedValue.toggle() }) {
                Image(systemName: "bubble.right")
                    .imageScale(.large)
                    .foregroundColor(.gray)
            }
            .accessibility(identifier: "commentsButton")
            
            Button(action: { downloadImage(imageUrl) }) {
                Image(systemName: "arrow.down.to.line")
                    .imageScale(.large)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: handleSaveTapped) {
                Image(systemName: didSave ? "bookmark.fill" : "bookmark")
                    .imageScale(.large)
                    .foregroundColor(didSave ? Color.primary : Color.secondary)
            }
            .accessibility(identifier: "saveButton")
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 5)
    }
}

struct PostLikesView: View {
    var likes: Int
    var body: some View {
        if likes > 0 {
            Text("\(likes) likes")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    FeedCell(post: Post.MOCK_POSTS[0])
}
