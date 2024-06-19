//
//  UserListView.swift
//  Instagram
//
//  Created by Mario Ban on 25.05.2024..
//

import SwiftUI

struct UserListView: View {
    @StateObject var viewModel: UserListViewModel
    @State private var searchText = ""
    
    private let config: UserList
    
    init(config: UserList, searchViewModel: SearchViewModel) {
        self.config = config
        _viewModel = StateObject(wrappedValue: UserListViewModel(searchViewModel: searchViewModel))
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredUsers) { user in
                    NavigationLink(value: user) {
                        HStack {
                            CircularProfileImageView(user: user, size: .xSmall)
                            VStack(alignment: .leading) {
                                Text(user.username)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color.primary)
                                
                                if let fullName = user.fullname {
                                    Text(fullName)
                                        .foregroundColor(Color.secondary)
                                }
                            }
                            .font(.footnote)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .background(Color(UIColor.systemBackground))
                    }
                }
            }
            .padding(.top, 8)
            .searchable(text: $searchText, prompt: "Search...")
            .onChange(of: searchText) { newValue in
                viewModel.filterUsers(for: newValue)
            }
        }
        .task {
            await viewModel.fetchUsers(forConfig: config)
        }
    }
}

#Preview {
    UserListView(config: .explore, searchViewModel: SearchViewModel())
}

