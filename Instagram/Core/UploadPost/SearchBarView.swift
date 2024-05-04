//
//  SearchBarView.swift
//  Instagram
//
//  Created by Mario Ban on 04.05.2024..
//

import SwiftUI
import MapKit
import CoreLocation

struct SearchBarView: View {
    @Binding var text: String
    var onSearchButtonClicked: (String) -> Void
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                    Text("Search for places...")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 5)
            }
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
                
                TextField("", text: $text, onCommit: {
                    onSearchButtonClicked(text)
                })
                .foregroundColor(.gray)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 5)
        }
    }
}
