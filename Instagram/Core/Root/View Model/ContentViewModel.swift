//
//  ContentViewModel.swift
//  Instagram
//
//  Created by Mario Ban on 14.02.2024..
//

import Foundation
import FirebaseAuth
import Combine

class ContentViewModel: ObservableObject {
    
    private let service = AuthService.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        setupSubscribers()
    }
    
    func setupSubscribers() {
        service.$userSession.sink { [weak self] userSession in
            print("User session updated: \(String(describing: userSession))")
            self?.userSession = userSession
        }
        .store(in: &cancellables)

        UserService.shared.$currentUser.sink { [weak self] currentUser in
            print("Current user updated: \(String(describing: currentUser))")
            self?.currentUser = currentUser
            if let user = currentUser {
                print("User details: \(user)")
            }
        }
        .store(in: &cancellables)
    }
}
