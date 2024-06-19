//
//  ProfileComposite.swift
//  Instagram
//
//  Created by Mario Ban on 19.06.2024..
//

import Foundation
import SwiftUI

protocol ProfileComponent {
    func render() -> AnyView
}

class ProfileComposite: ProfileComponent {
    private var components: [ProfileComponent] = []
    
    func add(component: ProfileComponent) {
        components.append(component)
    }
    
    func render() -> AnyView {
        AnyView(
            VStack {
                ForEach(0..<components.count, id: \.self) { index in
                    self.components[index].render()
                }
            }
        )
    }
}
