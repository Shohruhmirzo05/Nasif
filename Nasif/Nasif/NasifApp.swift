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
            ContentView()
//            TabbarView()
                .environment(\.locale, Locale(identifier: appLanguage))
                .environmentObject(viewModel)
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        _ = GoogleMapsManager.shared
        return true
    }
}

class GoogleMapsManager {
    static let shared = GoogleMapsManager()
    private init() {
        GMSServices.provideAPIKey("AIzaSyCMGqKlXqvlCuJBkoUiPjihq-jDr3aBPjA")
    }
}
