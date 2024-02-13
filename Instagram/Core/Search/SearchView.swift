//
//  SearchView.swift
//  Instagram
//
//  Created by Mario Ban on 08.12.2023..
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(0 ..< 15, id: \.self) { user in
                        HStack {
                            Image("vito-corleone")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            VStack(alignment: .leading) {
                                Text("vitocorleone")
                                    .fontWeight(.semibold)
                                Text("Vito Corleone")
                                    .font(.footnote)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 8)
                .searchable(text: $searchText, prompt: "Search...")
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


#Preview {
    SearchView()
}
