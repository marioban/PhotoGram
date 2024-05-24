//
//  ProfileViewModel.swift
//  Instagram
//
//  Created by Mario Ban on 24.05.2024..
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var user: User
    
    init(user: User) {
        self.user = user
    }
    
    //MARK: Following
    func follow()  {
        user.isFollowed = true
    }
 
    func unfollow()  {
        user.isFollowed = false
    }
    
    func checkIfUserIsFollowed()  {
        
    }
}
