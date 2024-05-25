//
//  UserListViewModel.swift
//  Instagram
//
//  Created by Mario Ban on 25.05.2024..
//

import Foundation

@MainActor
class UserListViewModel: ObservableObject {
    @Published var users = [User]()
    @Published var filteredUsers = [User]()
    
    init() {
        print("DEBUG: DID INIT")
    }
    
    func fetchUsers(forConfig config: UserList) async {
        do {
            let fetchedUsers = try await UserService.fetchUsers(forConfig: config)
            self.users = fetchedUsers
            self.filteredUsers = fetchedUsers
        } catch {
            print("DEBUG: ERROR \(error.localizedDescription)")
        }
    }
    
    func filterUsers(for query: String) {
        if query.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = users.filter { $0.username.lowercased().contains(query.lowercased()) }
        }
    }
}
