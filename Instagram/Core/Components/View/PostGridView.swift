//
//  PostGridView.swift
//  Instagram
//
//  Created by Mario Ban on 13.02.2024..
//

import SwiftUI
import Kingfisher

struct PostGridView: View {
    private let imageDimention: CGFloat = (UIScreen.main.bounds.width / 3) - 1
    @StateObject var viewModel: PostGridViewModel
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: PostGridViewModel(user: user))
    }
    
    
    private let gridItems: [GridItem] = [
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        
        LazyVGrid(columns: gridItems, spacing: 2) {
            ForEach(viewModel.posts) { post in
                KFImage(URL(string: post.imageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageDimention,height: imageDimention)
                    .clipped()
            }
        }
    }
}

#Preview {
    PostGridView(user: User.MOCK_USERS[0])
}
