//
//  LoginViewModel.swift
//  Instagram
//
//  Created by Mario Ban on 15.02.2024..
//

import Foundation

class LoginViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    func signIn() async throws {
        try await AuthService.shared.login(email: email, password: password)
    }
}
