//
//  LoadingFeedCell.swift
//  Instagram
//
//  Created by Mario Ban on 10.06.2024..
//

import SwiftUI

import SwiftUI

struct LoadingAnimationView: View {
    @State private var isAnimating = false

    var body: some View {
        Circle()
            .stroke(lineWidth: 5)
            .scaleEffect(isAnimating ? 1 : 0.5)
            .opacity(isAnimating ? 0.3 : 1)
            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimating)
            .onAppear {
                isAnimating = true
            }
            .foregroundColor(isAnimating ? .blue : .green)
            .frame(width: 50, height: 50)
    }
}


#Preview {
    LoadingAnimationView()
}
