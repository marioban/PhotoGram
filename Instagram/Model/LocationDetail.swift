//
//  LocationDetail.swift
//  Instagram
//
//  Created by Mario Ban on 14.06.2024..
//

import Foundation
import CoreLocation
import MapKit

struct LocationDetail: Codable, Hashable, Equatable, Identifiable {
    var id = UUID()  
    var coordinate: CLLocationCoordinate2D
    var streetName: String
    var city: String
    var establishmentName: String

    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case streetName
        case city
        case establishmentName
    }

    init(coordinate: CLLocationCoordinate2D, streetName: String, city: String, establishmentName: String) {
        self.coordinate = coordinate
        self.streetName = streetName
        self.city = city
        self.establishmentName = establishmentName
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.streetName = try container.decode(String.self, forKey: .streetName)
        self.city = try container.decode(String.self, forKey: .city)
        self.establishmentName = try container.decode(String.self, forKey: .establishmentName)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
        try container.encode(streetName, forKey: .streetName)
        try container.encode(city, forKey: .city)
        try container.encode(establishmentName, forKey: .establishmentName)
    }

    // Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(coordinate.latitude)
        hasher.combine(coordinate.longitude)
        hasher.combine(streetName)
        hasher.combine(city)
        hasher.combine(establishmentName)
    }

    // Equatable
    static func == (lhs: LocationDetail, rhs: LocationDetail) -> Bool {
        return lhs.coordinate.latitude == rhs.coordinate.latitude &&
               lhs.coordinate.longitude == rhs.coordinate.longitude &&
               lhs.streetName == rhs.streetName &&
               lhs.city == rhs.city &&
               lhs.establishmentName == rhs.establishmentName
    }
}
