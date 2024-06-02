//
//  ContentView.swift
//  Instagram
//
//  Created by Mario Ban on 07.12.2023..
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    @StateObject var registrationViewModel = RegistrationViewModel()
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        if authService.userSession != nil || authService.isAnonymous {
                    if authService.isAnonymous {
                        FeedView()  // Show only the FeedView in anonymous mode
                    } else {
                        MainTabView(user: authService.userSession!.toUser())  // Normal logged-in state
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
