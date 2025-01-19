//
//  ListingsView.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 09/01/25.
//

import SwiftUI

struct Apartment {
    var title: String
    var location: String
    var price: Int
    var image: String
    var sizeOfApartment: Int
    var bathrooms: Int
    var bedrooms: Int
    var status: AparmentStatus
    var type: String
}

struct ListingsView: View {
    
    let tabs = ["All", "Land", "Villa", "Apart.", "Floor", "Build.", "Other"]
    @State var selectedTab = "All"
    
    @State private var listings: [Apartment] = [
        Apartment(title: "Villa for sale", location: "Riyadh, Al-Ghadeer district", price: 3000, image: "", sizeOfApartment: 300, bathrooms: 2, bedrooms: 4, status: .available, type: "Villa"),
        Apartment(title: "Apartment for rent", location: "Jeddah, Al-Safa district", price: 150, image: "", sizeOfApartment: 120, bathrooms: 1, bedrooms: 2, status: .reserved, type: "Apart."),
        Apartment(title: "Land for sale", location: "Riyadh, Al-Naseem district", price: 100, image: "", sizeOfApartment: 0, bathrooms: 0, bedrooms: 0, status: .sold, type: "Land"),
    ]
    
    var filteredListings: [Apartment] {
        if selectedTab == "All" {
            return listings
        } else {
            return listings.filter { $0.type == selectedTab }
        }
    }
    
    func tabSelected(_ tab: String) {
        selectedTab = tab
    }
    
    @State var showMapView: Bool = false
    
    var body: some View {
        NavigationView {
           
            ScrollView {
                if showMapView {
                    GoogleMapView()
                } else {
                    VStack {
                        ForEach(filteredListings, id: \.title) { listing in
                            ApartmentListingCard(
                                title: listing.title,
                                location: listing.location,
                                price: listing.price,
                                image: listing.image,
                                sizeOfApartment: listing.sizeOfApartment,
                                bathrooms: listing.bathrooms,
                                bedrooms: listing.bedrooms,
                                status: listing.status,
                                attributes: [
                                    Attribute(type: "Bedroom", value: "4"),
                                    Attribute(type: "Bathroom", value: "8"),
                                    Attribute(type: "Price", value: "$30,000")
                                ]
                            )
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


