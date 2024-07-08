import SwiftUI
import PhotosUI
import MapKit
import UIKit

struct UploadPostView: View {
    @State private var caption = ""
    @State private var imagePickerPresented = false
    @StateObject var viewModel = UploadPostViewModel()
    @Binding var tabIndex: Int

    @State private var navigateToLocation = false

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isUploading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                        .padding()
                } else {
                    content
                }
            }
            .onAppear(perform: {
                imagePickerPresented = true
            })
            .photosPicker(isPresented: $imagePickerPresented, selection: $viewModel.selectedImage)
            .navigationBarTitle("New Post", displayMode: .inline)
            .navigationBarItems(
                leading: cancelButton,
                trailing: uploadButton.disabled(viewModel.isUploading)
            )
        }
    }

    var content: some View {
        VStack {
            postContent
            locationSection
            Spacer()
        }
    }

    var topBar: some View {
        HStack {
            cancelButton
            Spacer()
            Text("New Post")
                .fontWeight(.bold)
                .font(.title3)
            Spacer()
            uploadButton
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }

    var cancelButton: some View {
        Button("Cancel") {
            clearPostDataAndReturnToFeed()
        }
        .disabled(viewModel.isUploading)
    }

    var uploadButton: some View {
        Button("Upload") {
            Task {
                try await viewModel.uploadPost(caption: caption)
                clearPostDataAndReturnToFeed()
            }
        }
        .disabled(viewModel.isUploading)
    }

    var postContent: some View {
        HStack(spacing: 16) {
            if let image = viewModel.postImage {
                Button(action: {
                    imagePickerPresented = true
                }) {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipped()
                        .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle()) 
            }

            TextField("Enter your caption...", text: $caption)
                .frame(height: 100)
                .padding(8)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }

    var locationSection: some View {
        HStack {
            NavigationLink(destination: MapView(uploadPostViewModel: viewModel).navigationBarBackButtonHidden(true), isActive: $navigateToLocation) {
                Button("Location") {
                    navigateToLocation = true
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }

            if let locationDetail = viewModel.locationDetail {
                LocationDetailView(
                    coordinate: locationDetail.coordinate,
                    streetName: locationDetail.streetName,
                    city: locationDetail.city,
                    establishmentName: locationDetail.establishmentName
                )
            }
        }
    }

    func clearPostDataAndReturnToFeed() {
        caption = ""
        viewModel.selectedImage = nil
        viewModel.postImage = nil
        tabIndex = 0
    }
}
