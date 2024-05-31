//
//  NotificationViewModel.swift
//  Instagram
//
//  Created by Mario Ban on 30.05.2024..
//

import Foundation

@MainActor
class NotificationViewModel: ObservableObject {
    @Published var notifications = [Notification]()
    private let service: NotificationService
    private var currentUser: User?
    
    init(service: NotificationService) {
        self.service = service
        Task {await fetchNotifications()}
        self.currentUser = UserService.shared.currentUser
    }
    
    func fetchNotifications() async {
        do {
            self.notifications = try await service.fetchNotifications()
            try await updateNotifications()
        } catch {
            print("DEBUG: failed to fetch notifications \(error.localizedDescription)")
        }
    }
    
    private func updateNotifications() async throws {
        for i in 0 ..< notifications.count {
            var notification = notifications[i]
            
            notification.user = try await UserService.fetchUser(withUid: notification.notificationSenderUid)
            
            if let postId = notification.postId {
                notification.post = try await PostService.fetchPost(postId)
                notification.post?.user = self.currentUser
            }
            
            notifications[i] = notification
        }
    }
}
