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
    @StateObject var locationManager = LocationManager()
    @State var shouldCenterOnUserLocation: Bool = true
    
    let tabs = ["All", "Land", "Villa", "Apart.", "Floor", "Build.", "Other"]
    @State var selectedTab = "All"

    
    func tabSelected(_ tab: String) {
        selectedTab = tab
    }
    
    @State var showMapView: Bool = false
    @State var showListingDetailsView: Bool = false
    @State var showAddlistingView: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                if showMapView {
                    GoogleMapView(listings: viewModel.listings ?? [], userLocation: locationManager.userLocation, shouldCenterOnUserLocation: $shouldCenterOnUserLocation)
                        .frame(height: UIScreen.main.bounds.height * 0.9)
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
            VStack {
                AddListingButton()
                Button {
                    showMapView.toggle()
                    if showMapView {
                        shouldCenterOnUserLocation = true
                    }
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
    
    @ViewBuilder func AddListingButton() -> some View {
        HStack {
            Spacer()
            Button {
                showAddlistingView = true
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
        NavigationLink(destination: ListingAddView(), isActive: $showAddlistingView) {
            EmptyView()
        }
    }
    
    
}

#Preview {
    ListingsView()
    
}


