import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var trackingMode: MapUserTrackingMode = .follow
    @State private var navigateToLocation = false
    
    @Environment(\.dismiss) var dismiss
    var locationDetail: LocationDetail?
    @ObservedObject var uploadPostViewModel: UploadPostViewModel

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
                    .onAppear {
                        if let locationDetail = locationDetail {
                            let coordinate = locationDetail.coordinate
                            viewModel.region = MKCoordinateRegion(
                                center: coordinate,
                                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                            )
                            viewModel.addAnnotation(at: coordinate)
                        }
                    }
                
                SearchBarView(text: $viewModel.searchText, onSearchButtonClicked: viewModel.search)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 3))
                    .padding(.horizontal)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                leadingToolbarItem
                trailingToolbarItem
            }
            .navigationTitle("Map")
        }
    }
    
    private var leadingToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel") {
                dismiss()
            }
            .foregroundColor(.blue)
            .fontWeight(.bold)
        }
    }
    
    private var trailingToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Done") {
                if let currentAnnotation = viewModel.annotations.first {
                    let locationDetail = LocationDetail(
                        coordinate: currentAnnotation.annotation.coordinate,
                        streetName: viewModel.streetName,
                        city: viewModel.city,
                        establishmentName: viewModel.establishmentName
                    )
                    uploadPostViewModel.locationDetail = locationDetail
                }
                dismiss()
            }
            .foregroundColor(.blue)
            .fontWeight(.bold)
        }
    }
}
