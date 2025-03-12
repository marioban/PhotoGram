//
//  ProfileView.swift
//  Instagram
//
//  Created by Mario Ban on 07.12.2023..
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var viewModel: ProfileViewModel
    private var profileComposite: ProfileComposite
    
    init(user: User) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
        
        profileComposite = ProfileComposite()
        profileComposite.add(component: ProfileHeaderView(user: user))
        profileComposite.add(component: PostGridView(user: user) as! ProfileComponent)
    }
    
    var body: some View {
        ScrollView {
            profileComposite.render()
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ProfileView(user: User.MOCK_USERS[0])
}
