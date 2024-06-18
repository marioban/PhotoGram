//
//  NotificationCell.swift
//  Instagram
//
//  Created by Mario Ban on 30.05.2024..
//

import SwiftUI
import Kingfisher

struct NotificationCell: View {
    let notification: Notification
    
    var body: some View {
        HStack(alignment: .top) {
            NavigationLink(value: notification.user) {
                CircularProfileImageView(user: notification.user, size: .xSmall)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(notification.user?.username ?? "")
                    .font(.subheadline)
                    .fontWeight(.bold) +
                Text(" \(notification.type.notificationMessage)")
                    .font(.subheadline)
                Text(" \(notification.timestamp.timestampString())")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 8)
            
            Spacer()
            
            if notification.type != .follow {
                NavigationLink(value: notification.post) {
                    KFImage(URL(string: notification.post?.imageUrl ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipped()
                        .cornerRadius(5)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
                }
            } else {
                Button(action: {
                    print("DEBUG: follow")
                }) {
                    Text("Follow")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 88, height: 32)
                        .foregroundStyle(.white)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
