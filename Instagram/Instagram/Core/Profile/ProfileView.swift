//
//  ProfileView.swift
//  Instagram
//
//  Created by Mario Ban on 07.12.2023..
//

import SwiftUI

struct ProfileView: View {
    private let gridItems: [GridItem] = [
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                // MARK: Header
                VStack(spacing: 10) {
                    // MARK: Profile pic and stats
                    HStack {
                        Image("vito-corleone")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                        
                        Spacer()
                        
                        HStack(spacing: 8) {
                            UserStatView(value: 3, title: "Posts")
                            
                            UserStatView(value: 25, title: "Followers")
                            
                            UserStatView(value: 25, title: "Following")
                        }
                    }
                    .padding(.horizontal)
                    
                    //MARK: Name and bio
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Chadwick Boseman")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        
                        Text("Wakanda forever")
                            .font(.footnote)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    
                    //edit button
                    Button {
                        
                    } label: {
                        Text("Edit Profile")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(width: 360,height: 32)
                            .foregroundColor(.black)
                            .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                    
                    Divider()
                }
                
                //MARK: Post grid
                LazyVGrid(columns: gridItems, spacing: 2) {
                    ForEach(0...35, id: \.self) { index in
                        Image("vito-corleone")
                            .resizable()
                            .scaledToFill()
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundStyle(Color.black)
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
