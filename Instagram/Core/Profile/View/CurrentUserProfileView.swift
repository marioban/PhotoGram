//
//  CurrentUserProfileView.swift
//  Instagram
//
//  Created by Mario Ban on 13.02.2024..
//

import SwiftUI

struct CurrentUserProfileView: View {
    
    @StateObject var viewModel: ProfileViewModel
    
    init(user: User) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                // MARK: Header
                ProfileHeaderView(user: viewModel.user)
                
                //MARK: Post grid
                PostGridView(user: viewModel.user)
            }
            .refreshable {
                await viewModel.refreshProfile()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        AuthService.shared.signout()
                    } label: {
                        Image(systemName: "door.left.hand.open")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

#Preview {
    CurrentUserProfileView(user: User.MOCK_USERS[0])
}
