//
//  SearchViewModel.swift
//  Instagram
//
//  Created by Mario Ban on 15.02.2024..
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var users = [User]()
    @Published var filteredUsers = [User]()
    
    init() {
        Task { try await fetchAllUsers()}
    }
    
    @MainActor
    func fetchAllUsers() async throws {
        let fetchedUsers = try await UserService.fetchAllUsers()
        self.users = fetchedUsers
        self.filteredUsers = fetchedUsers
    }
    
    func filterUsers(for query: String) {
        if query.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = users.filter { $0.username.lowercased().contains(query.lowercased()) }
        }
    }
}
