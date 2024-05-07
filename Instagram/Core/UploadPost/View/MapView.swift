import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var trackingMode: MapUserTrackingMode = .follow
    @State private var navigateToLocation = false
    
    @Environment(\.dismiss) var dismiss
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
                        
                        SearchBarView(text: $viewModel.searchText, onSearchButtonClicked: viewModel.search)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 3))
                            .padding(.horizontal)
                    }
                    .navigationBarBackButtonHidden(true) 
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        if let currentAnnotation = viewModel.annotations.first {
                                    // Here you pass the real-time data instead of placeholder data
                                    let locationDetail = UploadPostViewModel.LocationDetail(
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
            .navigationTitle("Map")
        }
    }
}
