//
//  MapView.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 19/01/25.
//

import SwiftUI
import GoogleMaps

struct GoogleMapView: UIViewRepresentable {
    var listings: [Listing]
    var userLocation: CLLocationCoordinate2D?
    @Binding var shouldCenterOnUserLocation: Bool
    
    func makeUIView(context: Context) -> GMSMapView {
           let mapView = GMSMapView()

           mapView.isMyLocationEnabled = true
           mapView.settings.myLocationButton = false

           let myLocationButton = UIButton(type: .system)
           myLocationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
           myLocationButton.backgroundColor = .white
           myLocationButton.tintColor = .blue
           myLocationButton.layer.cornerRadius = 8
           myLocationButton.addTarget(context.coordinator, action: #selector(Coordinator.centerOnUserLocation), for: .touchUpInside)
           mapView.addSubview(myLocationButton)

           myLocationButton.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               myLocationButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -16),
               myLocationButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -16),
               myLocationButton.widthAnchor.constraint(equalToConstant: 40),
               myLocationButton.heightAnchor.constraint(equalToConstant: 40)
           ])

           if let userLocation = userLocation, shouldCenterOnUserLocation {
               let camera = GMSCameraPosition.camera(
                   withLatitude: userLocation.latitude,
                   longitude: userLocation.longitude,
                   zoom: 12
               )
               mapView.camera = camera
           } else {
               let camera = GMSCameraPosition.camera(
                   withLatitude: 37.7749,
                   longitude: -122.4194,
                   zoom: 12
               )
               mapView.camera = camera
           }

           updateMarkers(on: mapView)

           return mapView
       }

       func makeCoordinator() -> Coordinator {
           Coordinator(self)
       }

       class Coordinator: NSObject {
           var parent: GoogleMapView

           init(_ parent: GoogleMapView) {
               self.parent = parent
           }

           @objc func centerOnUserLocation() {
               if let userLocation = parent.userLocation {
                   let camera = GMSCameraPosition.camera(
                       withLatitude: userLocation.latitude,
                       longitude: userLocation.longitude,
                       zoom: 12
                   )
                   parent.shouldCenterOnUserLocation = true
               }
           }
       }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        if let userLocation = userLocation, shouldCenterOnUserLocation {
            let camera = GMSCameraPosition.camera(
                withLatitude: userLocation.latitude,
                longitude: userLocation.longitude,
                zoom: 12
            )
            uiView.animate(to: camera)
            
            DispatchQueue.main.async {
                self.shouldCenterOnUserLocation = false
            }
        }

        uiView.clear()
        updateMarkers(on: uiView)
    }

    private func updateMarkers(on mapView: GMSMapView) {
        for listing in listings {
            if let lat = Double(listing.latitude ?? ""), let long = Double(listing.longitude ?? "") {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
                marker.title = listing.title
                marker.snippet = listing.city
                marker.map = mapView
            }
        }
    }
}

import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 10 
        
        self.locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location.coordinate
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
