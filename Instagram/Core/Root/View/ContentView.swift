//
//  ContentView.swift
//  Instagram
//
//  Created by Mario Ban on 07.12.2023..
//

import SwiftUI
import FirebaseAnalytics

//firebase analytics and firebase performance
//login events: monitor when users successfully log in
//anonymous mode usage: track how often anonymous users access the app

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    @StateObject var registrationViewModel = RegistrationViewModel()
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        if authService.userSession != nil || authService.isAnonymous {
            if authService.isAnonymous {
                FeedView()  // Show only the FeedView in anonymous mode
                    .onAppear {
                        // Log anonymous user login event
                        Analytics.logEvent("anonymous_login", parameters: nil)
                    }
            } else {
                MainTabView(user: authService.userSession!.toUser())  // Normal logged-in state
                    .onAppear {
                        // Log user login event
                        Analytics.logEvent(AnalyticsEventLogin, parameters: [
                            "user_id": authService.userSession!.uid as NSObject
                        ])
                    }
            }
        } else {
            LoginView()  // Show login view when there is no session and not in anonymous mode
        }
        // Group {
        //     if viewModel.userSession == nil || authService.isAnonymous{
        //         LoginView()
        //             .environmentObject(registrationViewModel)
        //     } else if let currentUser = viewModel.currentUser{
        //         MainTabView(user: currentUser)
        //     }
        // }
    }
}

#Preview {
    ContentView()
}
