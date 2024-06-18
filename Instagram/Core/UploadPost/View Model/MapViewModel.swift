//
//  MapViewModel.swift
//  Instagram
//
//  Created by Mario Ban on 04.05.2024..
//

import Foundation
import MapKit
import CoreLocation

struct IdentifiableAnnotation: Identifiable {
    let id = UUID()
    var annotation: MKPointAnnotation
    
    var coordinate: CLLocationCoordinate2D {
        annotation.coordinate
    }
}

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion()
    @Published var searchText = ""
    @Published var locationSelected = false
    @Published var shouldFollowUserLocation = true
    @Published var annotations: [IdentifiableAnnotation] = []
    @Published var streetName: String = ""
    @Published var city: String = ""
    @Published var establishmentName: String = ""

    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func addAnnotation(at coordinate: CLLocationCoordinate2D) {
        annotations.removeAll()
        let newAnnotation = MKPointAnnotation()
        newAnnotation.coordinate = coordinate
        let identifiableAnnotation = IdentifiableAnnotation(annotation: newAnnotation)
        annotations.append(identifiableAnnotation)
    }

    func search(_ query: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = query
        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] response, error in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                if let mapItem = response?.mapItems.first {
                    let coordinate = mapItem.placemark.coordinate
                    strongSelf.region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                    strongSelf.locationSelected = true
                    strongSelf.shouldFollowUserLocation = false
                    strongSelf.addAnnotation(at: coordinate)
                    strongSelf.streetName = mapItem.placemark.thoroughfare ?? ""
                    strongSelf.city = mapItem.placemark.locality ?? ""
                    strongSelf.establishmentName = mapItem.name ?? ""  // Capture establishment name
                } else {
                    strongSelf.streetName = ""
                    strongSelf.city = ""
                    strongSelf.establishmentName = ""  // Reset if no results
                }
            }
        }
    }

    func resetSearch() {
        searchText = ""
        locationSelected = false
        shouldFollowUserLocation = true
        annotations = []
        locationManager.startUpdatingLocation()
    }
}
