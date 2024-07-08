//
//  PostGridView.swift
//  Instagram
//
//  Created by Mario Ban on 13.02.2024..
//

import SwiftUI
import Kingfisher

struct PostGridView: View, ProfileComponent {
    
    private let imageDimension: CGFloat = (UIScreen.main.bounds.width / 3) - 4
    @StateObject var viewModel: PostGridViewModel
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: PostGridViewModel(user: user))
    }
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 2), count: 3), spacing: 2) {
            ForEach(viewModel.posts) { post in
                NavigationLink(destination: FeedCell(post: post)) {
                    KFImage(URL(string: post.imageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageDimension, height: imageDimension)
                        .clipped()
                        .cornerRadius(5)
                        .shadow(radius: 2)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(2)
    }
    
    func render() -> AnyView {
        AnyView(self)
    }
}

#Preview {
    PostGridView(user: User.MOCK_USERS[0])
}
