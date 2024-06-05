//
//  UserStatView.swift
//  Instagram
//
//  Created by Mario Ban on 07.12.2023..
//

import SwiftUI

struct UserStatView: View {
    let value: Int
    let title: String
    
    var body: some View {
        VStack {
            Text("\(value)")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .scaleEffect(value > 0 ? 1.1 : 1.0)
                .animation(.easeOut(duration: 0.2), value: value)
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 16)
        .foregroundColor(.white)
        .shadow(color: value > 0 ? Color.blue.opacity(0.5) : Color.clear, radius: 5, x: 0, y: 5)
        .background(value > 0 ? AnyView(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing)) : AnyView(Color.gray.opacity(0.5)))
        .clipShape(Capsule())
    }
}

#Preview {
    UserStatView(value: 12, title: "Posts")
}
