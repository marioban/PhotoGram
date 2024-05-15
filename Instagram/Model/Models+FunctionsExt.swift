//
//  Models+FunctionsExt.swift
//  Instagram
//
//  Created by Mario Ban on 13.05.2024..
//

import SwiftUI
import MapKit

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No update action needed
    }
}

struct IdentifiableAnnotation: Identifiable {
    let id: UUID
    var annotation: MKPointAnnotation
    
    init(annotation: MKPointAnnotation) {
        self.id = UUID()
        self.annotation = annotation
    }
}


enum ImageType {
    case system(name: String)
    case asset(name: String)
}
