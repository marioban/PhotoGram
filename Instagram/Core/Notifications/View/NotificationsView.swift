//
//  NotificationsView.swift
//  Instagram
//
//  Created by Mario Ban on 30.05.2024..
//

import SwiftUI

struct NotificationsView: View {
    @StateObject var viewModel = NotificationViewModel(service: NotificationService())

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.notifications) { notification in
                        NotificationCell(notification: notification)
                    }
                }
                .padding(.top, 10)
            }
            .refreshable {
                await viewModel.fetchNotifications()
            }
            .navigationDestination(for: User.self, destination: { user in
                ProfileView(user: user)
            })
            .navigationDestination(for: Post.self, destination: { post in
                FeedCell(post: post)
            })
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("Instagram_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 32)
                }
            }
        }
    }
}

#Preview {
    NotificationsView()
}
