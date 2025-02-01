//
//  NasifApp.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 08/01/25.
//

import SwiftUI
import GoogleMaps

@main
struct NasifApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate // Connect AppDelegate here
    @AppStorage(AppStorageKeys.appLanguage) var appLanguage = Constants.defaultLanguage
    @StateObject var viewModel = ProfileViewModel()

    var body: some Scene {
        WindowGroup {
            TabbarView()
//            GoogleMapView()
                .environment(\.locale, Locale(identifier: appLanguage))
                .environmentObject(viewModel)
        }
    }
}

//class AppDelegate: UIResponder, UIApplicationDelegate {
//    func application(
//        _ application: UIApplication,
//        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//    ) -> Bool {
//        // Provide the API key for Google Maps
//        GMSServices.provideAPIKey("AIzaSyCMGqKlXqvlCuJBkoUiPjihq-jDr3aBPjA")
//        return true
//    }
//}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Initialize Google Maps SDK via the shared manager
        _ = GoogleMapsManager.shared
        return true
    }
}

class GoogleMapsManager {
    static let shared = GoogleMapsManager()
    
    private init() {
        // Initialize Google Maps SDK
        GMSServices.provideAPIKey("AIzaSyCMGqKlXqvlCuJBkoUiPjihq-jDr3aBPjA")
    }
    
    // Add any other Google Maps-related methods here
}
