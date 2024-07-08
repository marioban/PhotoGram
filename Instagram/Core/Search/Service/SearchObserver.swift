//
//  SearchObserver.swift
//  Instagram
//
//  Created by Mario Ban on 19.06.2024..
//

import Foundation

protocol SearchObserver: AnyObject {
    func onUsersUpdated(users: [User])
}
