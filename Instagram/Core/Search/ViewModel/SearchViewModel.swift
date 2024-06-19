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
    private var observers = [SearchObserver]()
    
    init() {
        Task { try await fetchAllUsers() }
    }
    
    func addObserver(_ observer: SearchObserver) {
        observers.append(observer)
    }
    
    func removeObserver(_ observer: SearchObserver) {
        observers.removeAll { $0 === observer }
    }
    
    @MainActor
    func fetchAllUsers() async throws {
        let fetchedUsers = try await UserService.fetchAllUsers()
        self.users = fetchedUsers
        self.filteredUsers = fetchedUsers
        notifyObservers()
    }
    
    func filterUsers(for query: String) {
        if query.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = users.filter { $0.username.lowercased().contains(query.lowercased()) }
        }
        notifyObservers()
    }
    
    private func notifyObservers() {
        for observer in observers {
            observer.onUsersUpdated(users: filteredUsers)
        }
    }
}
