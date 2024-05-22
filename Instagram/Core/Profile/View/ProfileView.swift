//
//  ProfileView.swift
//  Instagram
//
//  Created by Mario Ban on 07.12.2023..
//

import SwiftUI

struct ProfileView: View {
    
    let user: User
    
    var body: some View {
        ScrollView {
            // MARK: Header
            ProfileHeaderView(user: user)
            
            //MARK: Post grid
            PostGridView(user: user)
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ProfileView(user: User.MOCK_USERS[0])
}
