//
//  MapView.swift
//  Instagram
//
//  Created by Mario Ban on 04.05.2024..
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var trackingMode: MapUserTrackingMode = .follow
    @State private var navigateToLocation = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Map(coordinateRegion: $viewModel.region,
                    interactionModes: .all,
                    showsUserLocation: true,
                    userTrackingMode: $trackingMode,
                    annotationItems: viewModel.annotations) { item in
                        MapPin(coordinate: item.annotation.coordinate, tint: .red)
                    }
                    .ignoresSafeArea(edges: .all)

                SearchBarView(text: $viewModel.searchText, onSearchButtonClicked: viewModel.search)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 3))
                    .padding(.horizontal)
            }
            .navigationBarBackButtonHidden(true) // Hides the back button
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { //viewModel.resetSearch
                        navigateToLocation = true
                    }
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
                    .background(
                        NavigationLink(
                            destination: UploadPostView(tabIndex: .constant(0)).navigationBarBackButtonHidden(true),
                            isActive: $navigateToLocation
                        ) {
                            EmptyView()
                        }
                    )
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Text("Done").foregroundColor(.blue).fontWeight(.bold)
                    }
                }
            }
            .navigationTitle("Map")
        }
    }
}


#Preview{
    MapView()
}
