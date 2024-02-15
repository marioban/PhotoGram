//
//  RegistrationViewModel.swift
//  Instagram
//
//  Created by Mario Ban on 14.02.2024..
//

import Foundation

class RegistrationViewModel: ObservableObject {
    
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    
    func createUser() async throws {
        try await AuthService.shared.createUser(email: email, password: password, username: username)
        username = ""
        email = ""
        password = ""
    }
    
}
