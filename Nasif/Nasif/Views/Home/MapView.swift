//
//  MapView.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 19/01/25.
//

import SwiftUI
import GoogleMaps


struct GoogleMapView: UIViewRepresentable {
    func makeUIView(context: Context) -> GMSMapView {
        // Create a GMSCameraPosition
        let camera = GMSCameraPosition.camera(withLatitude: 37.7749, longitude: -122.4194, zoom: 10)
        
        // Create GMSMapViewOptions
        let options = GMSMapViewOptions()
//        options.compassButton = true // Example: Enabling compass
//        options.tiltGestures = true // Example: Enabling tilt gestures
//        options.camera = GMSCameraPosition.
        
        // Initialize GMSMapView with options
        let mapView = GMSMapView(options: options)
        mapView.camera = camera // Set the camera position

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        // You can update the map here if needed, e.g., changing camera position
    }
}

#Preview {
    GoogleMapView()
}
