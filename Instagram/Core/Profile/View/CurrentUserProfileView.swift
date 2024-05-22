//
//  CurrentUserProfileView.swift
//  Instagram
//
//  Created by Mario Ban on 13.02.2024..
//

import SwiftUI

struct CurrentUserProfileView: View {
    
    let user: User
    
    var body: some View {
        NavigationStack {
            ScrollView {
                // MARK: Header
                ProfileHeaderView(user: user)
                
                //MARK: Post grid
                PostGridView(user: user)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        AuthService.shared.signout()
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
            }
        }
    }
}

#Preview {
    CurrentUserProfileView(user: User.MOCK_USERS[0])
}
