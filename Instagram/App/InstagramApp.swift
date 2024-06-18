//
//  InstagramApp.swift
//  Instagram
//
//  Created by Mario Ban on 07.12.2023..
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import RealmSwift

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct InstagramApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authService = AuthService.shared
    @StateObject private var registrationViewModel = RegistrationViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(SavedPostsViewModel())
                .environmentObject(authService) 
                .environmentObject(registrationViewModel)
        }
    }
}
