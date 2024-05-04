//
//  LocationDetailView.swift
//  Instagram
//
//  Created by Mario Ban on 04.05.2024..
//


import SwiftUI
import CoreLocation

struct LocationDetailView: View {
    var coordinate: CLLocationCoordinate2D
    var streetName: String
    var city: String
    var establishmentName: String

    var body: some View {
        VStack {
            if !establishmentName.isEmpty {
                if establishmentName != city {
                    Text("\(establishmentName), \(city)")
                } else {
                    Text(city)
                }
            } else if !streetName.isEmpty && !city.isEmpty {
                Text("\(streetName), \(city)")
            } else if !city.isEmpty {
                Text(city)
            } else if !streetName.isEmpty {
                Text(streetName)
            } else {
                Text("Location details not available")
            }
        }
        .padding()
    }
}
