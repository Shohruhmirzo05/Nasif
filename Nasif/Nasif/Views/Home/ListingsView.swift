//
//  ListingsView.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 09/01/25.
//

import SwiftUI

struct ApartmentMock {
    var title: String
    var location: String
    var price: Int
    var image: String
    var sizeOfApartment: Int
    var bathrooms: Int
    var bedrooms: Int
    var type: String
}

@MainActor
class ListingsViewModel: ObservableObject {
    @Published var listings: [Listing]? = []
    @Published var listing: Listing?
    @Published var isListingLoading: Bool = false
    
    init() {
        getListings()
    }
    
    func getListings() {
        isListingLoading = true
        
        Task {
            do {
                let response = try await APIClient.shared.callWithStatusCode(.getListings, decodeTo: [Listing].self)
                DispatchQueue.main.async {
                    self.listings = response.data
                    self.isListingLoading = false
                }
            } catch {
                self.isListingLoading = false
                print(error)
                print(error.localizedDescription)
                print("error in loading listings")
            }
        }
    }
    
    func getListingsByID(listingID: Int?) {
        Task {
            let response = try await APIClient.shared.callWithStatusCode(.getlistingById(listingID: listingID ?? 0), decodeTo: Listing.self)
            DispatchQueue.main.async {
                self.listing = response.data
            }
        }
    }
}

struct ListingsView: View {
    
    @StateObject var viewModel = ListingsViewModel()
    
    let tabs = ["All", "Land", "Villa", "Apart.", "Floor", "Build.", "Other"]
    @State var selectedTab = "All"
    
//    @State private var listings: [ApartmentMock] = [
//        ApartmentMock(title: "Villa for sale", location: "Riyadh, Al-Ghadeer district", price: 3000, image: "", sizeOfApartment: 300, bathrooms: 2, bedrooms: 4, status: .available, type: "Villa"),
//        ApartmentMock(title: "Apartment for rent", location: "Jeddah, Al-Safa district", price: 150, image: "", sizeOfApartment: 120, bathrooms: 1, bedrooms: 2, status: .reserved, type: "Apart."),
//        ApartmentMock(title: "Land for sale", location: "Riyadh, Al-Naseem district", price: 100, image: "", sizeOfApartment: 0, bathrooms: 0, bedrooms: 0, status: .sold, type: "Land"),
//    ]
    
//    var filteredListings: [ApartmentMock] {
//        if selectedTab == "All" {
//            return listings
//        } else {
//            return listings.filter { $0.type == selectedTab }
//        }
//    }
    
    func tabSelected(_ tab: String) {
        selectedTab = tab
    }
    
    @State var showMapView: Bool = false
    @State var showListingDetailsView: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                if showMapView {
                    GoogleMapView()
                } else {
                    VStack {
                        if let listings = viewModel.listings {
                            ForEach(listings) { listing in
                                NavigationLink {
                                    ListingDetailsView(listing: listing)
                                } label: {
                                    ApartmentListingCardView(listing: listing)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
//            .navigationDestination(isPresented: $showListingDetailsView){
//                ApartmentListingCardView(listing: viewModel.listing ?? .mock)
//            }
            .safeAreaInset(edge: .bottom, content: MapSwitcher)
            .safeAreaInset(edge: .top) {
                CustomTabPickerView(selectedTab: $selectedTab, tabs: tabs)
                    .padding(.horizontal, 4)
                    .padding(.vertical)
                    .background(.white)
                    .animation(.easeInOut, value: selectedTab)
                    .transition(.move(edge: .leading))
            }
            
        }
    }
    
    @ViewBuilder func MapSwitcher() -> some View {
        HStack {
            Spacer()
            Button {
                showMapView.toggle()
            } label: {
                Image(systemName: "map")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(12)
                    .background(Color.gray)
                    .clipShape(Circle())
                    .foregroundStyle(.white)
                    .padding()
            }
        }
    }
}

#Preview {
    ListingsView()
    
}

