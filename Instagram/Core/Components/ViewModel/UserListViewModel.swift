//
//  UserListViewModel.swift
//  Instagram
//
//  Created by Mario Ban on 25.05.2024..
//

import Foundation

@MainActor
class UserListViewModel: ObservableObject, SearchObserver {
    @Published var users = [User]()
    @Published var filteredUsers = [User]()
    private let searchViewModel: SearchViewModel
    
    init(searchViewModel: SearchViewModel) {
        self.searchViewModel = searchViewModel
        searchViewModel.addObserver(self)
    }
    
    deinit {
        searchViewModel.removeObserver(self)
    }
    
    func fetchUsers(forConfig config: UserList) async {
        do {
            let fetchedUsers = try await UserService.fetchUsers(forConfig: config)
            self.users = fetchedUsers
            self.filteredUsers = fetchedUsers
            searchViewModel.filterUsers(for: "")
        } catch {
            print("DEBUG: ERROR \(error.localizedDescription)")
        }
    }
    
    func filterUsers(for query: String) {
        searchViewModel.filterUsers(for: query)
    }
    
    func onUsersUpdated(users: [User]) {
        self.filteredUsers = users
    }
}
