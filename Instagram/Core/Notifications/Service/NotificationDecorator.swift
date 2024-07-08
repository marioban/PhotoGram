//
//  NotificationDecorator.swift
//  Instagram
//
//  Created by Mario Ban on 19.06.2024..
//

import Foundation

protocol NotificationServiceProtocol {
    func fetchNotifications() async throws -> [Notification]
    func uploadNotification(toUid uid: String, type: NotificationType, post: Post?)
    func deleteNotification(toUid uid: String, type: NotificationType, post: Post?) async throws
}


class BaseNotificationDecorator: NotificationServiceProtocol {
    private let wrapped: NotificationServiceProtocol
    
    init(wrapped: NotificationServiceProtocol) {
        self.wrapped = wrapped
    }
    
    func fetchNotifications() async throws -> [Notification] {
        return try await wrapped.fetchNotifications()
    }
    
    func uploadNotification(toUid uid: String, type: NotificationType, post: Post?) {
        wrapped.uploadNotification(toUid: uid, type: type, post: post)
    }
    
    func deleteNotification(toUid uid: String, type: NotificationType, post: Post?) async throws {
        try await wrapped.deleteNotification(toUid: uid, type: type, post: post)
    }
}


class LoggingNotificationDecorator: BaseNotificationDecorator {
    override func fetchNotifications() async throws -> [Notification] {
        let notifications = try await super.fetchNotifications()
        print("Fetched \(notifications.count) notifications.")
        return notifications
    }
    
    override func uploadNotification(toUid uid: String, type: NotificationType, post: Post?) {
        super.uploadNotification(toUid: uid, type: type, post: post)
        print("Uploaded \(type) notification to user \(uid).")
    }
    
    override func deleteNotification(toUid uid: String, type: NotificationType, post: Post?) async throws {
        try await super.deleteNotification(toUid: uid, type: type, post: post)
        print("Deleted \(type) notification for user \(uid).")
    }
}
