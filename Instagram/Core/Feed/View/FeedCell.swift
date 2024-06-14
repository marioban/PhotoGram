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
            
            PostTimeStampView(timeStamp: viewModel.post.timeStamp ?? Timestamp(date: Date()))
                .padding([.horizontal, .bottom], 10)
            
        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color(UIColor.label).opacity(0.4), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 5)
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .sheet(isPresented: $showComments) {
            CommentsView(post: viewModel.post)
        }
        .sheet(item: $selectedLocation) { location in
            MapView(locationDetail: location, uploadPostViewModel: UploadPostViewModel())
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
    
    private func handleSaveTapped() {
        Task {
            await viewModel.toggleSave()
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
                CircularProfileImageView(user: user, size: .medium)
                Text(user.username)
                    .font(.headline)
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
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipped()
            } else {
                Color.gray.frame(height: 200)
            }
        }
        .cornerRadius(10)
        .padding(.horizontal)
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
                    .foregroundColor(didSave ? .black : .gray)
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
        .font(.footnote)
    }
}

struct PostTimeStampView: View {
    var timeStamp: Timestamp
    var body: some View {
        Text(timeStamp.timestampString())
            .font(.caption)
            .foregroundColor(.gray)
    }
}

/*
 #Preview {
 FeedCell(viewModel: FeedCellViewModel(post: Post.MOCK_POSTS[0]))
 }*/
