//
//  ChooseLocation.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 07/02/25.
//

import SwiftUI
import GoogleMaps
import CoreLocation

class LocationViewModel: ObservableObject {
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    @Published var cityName: String = ""
    @Published var countryName: String = ""
    
    func updateLocation(latitude: Double, longitude: Double, city: String, country: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.cityName = city
        self.countryName = country
    }
}


//struct ChooseLocationView: View {
//    @State var selectedLocation: CLLocationCoordinate2D?
//    @State var cityName: String = ""
//    @State var countryName: String = ""
//    @State var shouldShowPin: Bool = false
//    @State var latitude: Double = 0.0
//    @State var longitude: Double = 0.0
//    @State var shouldShowUserLocation: Bool = false
//
//    let geocoder = CLGeocoder()
//
//    var body: some View {
//        VStack {
//            VStack {
//                TextField("Enter City", text: $cityName)
//                    .padding()
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .onChange(of: cityName) { _ in
//                        searchCity()
//                    }
//                TextField("Enter Country", text: $countryName)
//                    .padding()
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .onChange(of: countryName) { _ in
//                        searchCity()
//                    }
//            }
//            .padding()
//
//            GoogleMapViewForChoosingLocation(
//                selectedLocation: $selectedLocation, shouldCenterOnUserLocation: $shouldShowUserLocation,
//                shouldShowPin: $shouldShowPin,
//                latitude: $latitude,
//                longitude: $longitude
//            )
//            .frame(height: 500)
//            .edgesIgnoringSafeArea(.horizontal)
//
//            if let location = selectedLocation {
//                Text("Selected Location:")
//                    .font(.headline)
//                    .padding(.top)
//                Text("Latitude: \(location.latitude), Longitude: \(location.longitude)")
//                    .font(.body)
//                    .padding()
//
//                Button(action: {
//                    sendLocationToAPI(latitude: location.latitude, longitude: location.longitude)
//                }) {
//                    Text("Send to API")
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.blue)
//                        .cornerRadius(8)
//                }
//                .padding()
//            }
//        }
//    }
//
//    func searchCity() {
//        if !cityName.isEmpty {
//            let address = "\(cityName), \(countryName)"
//
//            geocoder.geocodeAddressString(address) { (placemarks, error) in
//                if let error = error {
//                    print("Geocoding error: \(error.localizedDescription)")
//                    return
//                }
//
//                if let placemark = placemarks?.first,
//                   let location = placemark.location {
//                    self.latitude = location.coordinate.latitude
//                    self.longitude = location.coordinate.longitude
//                    self.selectedLocation = location.coordinate
//                    self.shouldShowPin = true
//                }
//            }
//        }
//    }
//
//    func sendLocationToAPI(latitude: Double, longitude: Double) {
//        print("Sending location to API: Lat: \(latitude), Long: \(longitude)")
//    }
//}
//
//struct GoogleMapViewForChoosingLocation: UIViewRepresentable {
//    @Binding var selectedLocation: CLLocationCoordinate2D?
//    @Binding var shouldCenterOnUserLocation: Bool
//    @Binding var shouldShowPin: Bool
//    @Binding var latitude: Double
//    @Binding var longitude: Double
//
//    func makeUIView(context: Context) -> GMSMapView {
//        let mapView = GMSMapView()
//
//        mapView.isMyLocationEnabled = true
//        mapView.settings.myLocationButton = false
//
//        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTapGesture(_:)))
//        mapView.addGestureRecognizer(tapGesture)
//
//        let myLocationButton = UIButton(type: .system)
//        myLocationButton.backgroundColor = .white
//        myLocationButton.tintColor = .blue
//        myLocationButton.layer.cornerRadius = 8
//        myLocationButton.addTarget(context.coordinator, action: #selector(Coordinator.centerOnUserLocation), for: .touchUpInside)
//        mapView.addSubview(myLocationButton)
//        NSLayoutConstraint.activate([
//            myLocationButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -16),
//            myLocationButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -16),
//            myLocationButton.widthAnchor.constraint(equalToConstant: 40),
//            myLocationButton.heightAnchor.constraint(equalToConstant: 40)
//        ])
//        if let userLocation = selectedLocation, shouldCenterOnUserLocation {
//            let camera = GMSCameraPosition.camera(
//                withLatitude: userLocation.latitude,
//                longitude: userLocation.longitude,
//                zoom: 12
//            )
//            mapView.camera = camera
//        } else {
//            let camera = GMSCameraPosition.camera(
//                withLatitude: 37.7749,
//                longitude: -122.4194,
//                zoom: 12
//            )
//            mapView.camera = camera
//        }
//
//        return mapView
//    }
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(self)
//    }
//
//    func updateUIView(_ uiView: GMSMapView, context: Context) {
//        if shouldShowPin, let location = selectedLocation {
//            uiView.clear()
//
//            let marker = GMSMarker()
//            marker.position = location
//            marker.title = "Selected Location"
//            marker.map = uiView
//            marker.isDraggable = true
//            marker.icon = UIImage(named: "pin")
//            uiView.animate(to: GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 12))
//        }
//    }
//
//    class Coordinator: NSObject {
//        var parent: GoogleMapViewForChoosingLocation
//
//        init(_ parent: GoogleMapViewForChoosingLocation) {
//            self.parent = parent
//        }
//
//        @objc func centerOnUserLocation() {
//            if let userLocation = parent.selectedLocation {
//                let camera = GMSCameraPosition.camera(
//                    withLatitude: userLocation.latitude,
//                    longitude: userLocation.longitude,
//                    zoom: 12
//                )
//
//                parent.shouldCenterOnUserLocation = true
//            }
//        }
//
//        @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
//            let mapView = gesture.view as! GMSMapView
//            let point = gesture.location(in: mapView)
//            let coordinate = mapView.projection.coordinate(for: point)
//
//            parent.selectedLocation = coordinate
//            parent.shouldShowPin = true
//            parent.latitude = coordinate.latitude
//            parent.longitude = coordinate.longitude
//        }
//    }
//}
//
//struct ChooseLocationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChooseLocationView()
//    }
//}


struct ChooseLocationView: View {
    @State var selectedLocation: CLLocationCoordinate2D?
    @State var cityName: String = ""
    @State var countryName: String = ""
    @State var shouldShowPin: Bool = false
    @State var latitude: Double = 0.0
    @State var longitude: Double = 0.0
    @State var shouldShowUserLocation: Bool = false
    @State var isLocationSelected: Bool = false  // Track if a location is selected
    
    let geocoder = CLGeocoder()
    
    var body: some View {
        VStack {
            VStack {
                TextField("Enter City", text: $cityName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: cityName) { _ in
                        searchCity()
                    }
                TextField("Enter Country", text: $countryName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: countryName) { _ in
                        searchCity()
                    }
            }
            .padding()
            
            GoogleMapViewForChoosingLocation(
                selectedLocation: $selectedLocation, shouldCenterOnUserLocation: $shouldShowUserLocation,
                shouldShowPin: $shouldShowPin,
                latitude: $latitude,
                longitude: $longitude,
                isLocationSelected: $isLocationSelected  // Pass the binding to track location selection
            )
            .frame(height: 500)
            .edgesIgnoringSafeArea(.horizontal)
            
            if isLocationSelected {
                Text("Selected Location:")
                    .font(.headline)
                    .padding(.top)
                Text("Latitude: \(latitude), Longitude: \(longitude)")
                    .font(.body)
                    .padding()
                
                Button(action: {
                    sendLocationToAPI(latitude: latitude, longitude: longitude)
                }) {
                    Text("Send to API")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
    }
    
    func searchCity() {
        if !cityName.isEmpty {
            let address = "\(cityName), \(countryName)"
            
            geocoder.geocodeAddressString(address) { (placemarks, error) in
                if let error = error {
                    print("Geocoding error: \(error.localizedDescription)")
                    return
                }
                
                if let placemark = placemarks?.first,
                   let location = placemark.location {
                    self.latitude = location.coordinate.latitude
                    self.longitude = location.coordinate.longitude
                    self.selectedLocation = location.coordinate
                    self.isLocationSelected = true  // Mark location as selected
                    self.shouldShowPin = true
                }
            }
        }
    }
    
    func sendLocationToAPI(latitude: Double, longitude: Double) {
        print("Sending location to API: Lat: \(latitude), Long: \(longitude)")
    }
}

struct GoogleMapViewForChoosingLocation: UIViewRepresentable {
    @Binding var selectedLocation: CLLocationCoordinate2D?
    @Binding var shouldCenterOnUserLocation: Bool
    @Binding var shouldShowPin: Bool
    @Binding var latitude: Double
    @Binding var longitude: Double
    @Binding var isLocationSelected: Bool  // Track if location is selected
    
    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView()
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = false
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTapGesture(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        let myLocationButton = UIButton(type: .system)
        myLocationButton.backgroundColor = .white
        myLocationButton.tintColor = .blue
        myLocationButton.layer.cornerRadius = 8
        myLocationButton.addTarget(context.coordinator, action: #selector(Coordinator.centerOnUserLocation), for: .touchUpInside)
        mapView.addSubview(myLocationButton)
        NSLayoutConstraint.activate([
            myLocationButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -16),
            myLocationButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -16),
            myLocationButton.widthAnchor.constraint(equalToConstant: 40),
            myLocationButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        if let userLocation = selectedLocation, shouldCenterOnUserLocation {
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
        
        return mapView
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        if shouldShowPin, let location = selectedLocation {
            uiView.clear()
            
            let marker = GMSMarker()
            marker.position = location
            marker.title = "Selected Location"
            marker.map = uiView
            marker.isDraggable = true
            marker.icon = UIImage(named: "pin")
            uiView.animate(to: GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 12))
            
            // Update latitude, longitude, and set location as selected
            latitude = location.latitude
            longitude = location.longitude
            isLocationSelected = true
        }
    }
    
    class Coordinator: NSObject {
        var parent: GoogleMapViewForChoosingLocation
        
        init(_ parent: GoogleMapViewForChoosingLocation) {
            self.parent = parent
        }
        
        @objc func centerOnUserLocation() {
            if let userLocation = parent.selectedLocation {
                let camera = GMSCameraPosition.camera(
                    withLatitude: userLocation.latitude,
                    longitude: userLocation.longitude,
                    zoom: 12
                )
                
                parent.shouldCenterOnUserLocation = true
            }
        }
        
        @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
            let mapView = gesture.view as! GMSMapView
            let point = gesture.location(in: mapView)
            let coordinate = mapView.projection.coordinate(for: point)
            
            parent.selectedLocation = coordinate
            parent.shouldShowPin = true
            parent.latitude = coordinate.latitude
            parent.longitude = coordinate.longitude
            parent.isLocationSelected = true  // Mark location as selected
        }
    }
}

