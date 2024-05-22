import SwiftUI
import PhotosUI
import MapKit

struct UploadPostView: View {
    @State private var caption = ""
    @State private var imagePickerPresented = false
    @StateObject var viewModel = UploadPostViewModel()
    @Binding var tabIndex: Int
    
    // State variable to control navigation
    @State private var navigateToLocation = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        clearPostDataAndReturnToFeed()
                    } label: {
                        Text("Cancel")
                            .fontWeight(.semibold)
                    }
                    
                    Spacer()
                    
                    Text("New post")
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button {
                        Task {
                            try await viewModel.uploadPost(caption: caption)
                            clearPostDataAndReturnToFeed()
                        }
                    } label: {
                        Text("Upload")
                            .fontWeight(.semibold)
                    }
                }
                .padding(.horizontal)
                
                
                HStack(spacing: 8) {
                    if let image = viewModel.postImage {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipped()
                    }
                    
                    TextField("Enter your caption", text: $caption, axis: .vertical)
                        .frame(height: 100)
                }
                .padding()
                
                // Location Button and Display
                HStack {
                    Button("Location") {
                        navigateToLocation = true
                    }
                    .padding()
                    .background(
                        NavigationLink(
                            destination: MapView(uploadPostViewModel: viewModel).navigationBarBackButtonHidden(true),
                            isActive: $navigateToLocation
                        ) {
                            EmptyView()
                        }
                    )

                    if let locationDetail = viewModel.locationDetail {
                        LocationDetailView(
                            coordinate: locationDetail.coordinate,
                            streetName: locationDetail.streetName,
                            city: locationDetail.city,
                            establishmentName: locationDetail.establishmentName
                        )
                    }
                }
                
                Spacer()
            }
            .onAppear(perform: {
                imagePickerPresented.toggle()
            })
            .photosPicker(isPresented: $imagePickerPresented, selection: $viewModel.selectedImage)
        }
    }
    
    func clearPostDataAndReturnToFeed() {
        caption = ""
        viewModel.selectedImage = nil
        viewModel.postImage = nil
        tabIndex = 0
    }
}
