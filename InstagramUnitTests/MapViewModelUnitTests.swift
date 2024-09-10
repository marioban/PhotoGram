//
//  MapViewModelUnitTests.swift
//  InstagramUnitTests
//
//  Created by Mario Ban on 03.09.2024..
//

import XCTest
import MapKit
import CoreLocation
@testable import Instagram

final class MapViewModelTests: XCTestCase {
    
    var viewModel: MapViewModel!
    var mockLocationManager: CLLocationManager!
    
    override func setUp() {
        super.setUp()
        mockLocationManager = CLLocationManager()
        viewModel = MapViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        mockLocationManager = nil
        super.tearDown()
    }
    
    func testAddAnnotation() {
        let coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        viewModel.addAnnotation(at: coordinate)
        
        XCTAssertEqual(viewModel.annotations.count, 1, "There should be exactly one annotation")
        XCTAssertEqual(viewModel.annotations.first?.annotation.coordinate.latitude, coordinate.latitude, "Annotation latitude should match the provided coordinate")
        XCTAssertEqual(viewModel.annotations.first?.annotation.coordinate.longitude, coordinate.longitude, "Annotation longitude should match the provided coordinate")
    }
    
    
    func testResetSearch() {
        viewModel.searchText = "Some Place"
        viewModel.locationSelected = true
        viewModel.shouldFollowUserLocation = false
        viewModel.annotations.append(IdentifiableAnnotation(annotation: MKPointAnnotation()))
        
        viewModel.resetSearch()
        
        XCTAssertEqual(viewModel.searchText, "", "Search text should be reset to empty")
        XCTAssertFalse(viewModel.locationSelected, "Location should not be marked as selected after reset")
        XCTAssertTrue(viewModel.shouldFollowUserLocation, "User location should be followed after reset")
        XCTAssertTrue(viewModel.annotations.isEmpty, "Annotations should be cleared after reset")
    }
}
