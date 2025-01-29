//
//  ListingDetails.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 29/01/25.
//

import SwiftUI

struct ListingDetailsView: View {
    
    @StateObject var viewModel = ListingsViewModel()
    let listing: Listing?
    @State var layoutDirection = LayoutDirection(.leftToRight)
    @EnvironmentObject var profileViewModel: ProfileViewModel
          
    var body: some View {
        
//        @State var layoutDirection = LayoutDirection(.leftToRight)
        
        NavigationView {
            ScrollView {
                VStack(spacing: 38) {
                    ImageSection()
                    Subsections()
                    Features()
                    Description()
                    AdditionalInfo()
                }
                .padding(.bottom)
            }
            .navigationBarBackButtonHidden()
            .onAppear {
                viewModel.getListingsByID(listingID: listing?.id)
            }
        }
        .environment(\.layoutDirection, profileViewModel.layoutDirection ?? .rightToLeft)
    }
    
    @ViewBuilder func ImageSection() -> some View {
        if let images = listing?.additionalImagesArray {
            TabView {
                ForEach(0..<(images.count), id: \.self) { image in
                    CachedImage(imageUrl: images[image])
                        .overlay {
                            Group {
                                if listing?.availability == 1 {
                                    Text("Available")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color(hex: "#287346"))
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                } else if listing?.availability == 2 {
                                    Text("Sold")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color(hex: "#C50000"))
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                } else if listing?.availability == 3 {
                                    Text("Reserved")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color(hex: "#7A12E9"))
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                }
                            }
                            .padding(24)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        }
                        .tag(image)
                        .clipped()
                }
            }
            .tabViewStyle(.page)
            .frame(width: .screenWidth, height: 249)
            .frame(width: .screenWidth, height: 249)
            .background {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 64, height: 64)
                    .foregroundStyle(.gray)
            }
            .padding(.bottom, 28)
        }
        
        HStack {
            Image(.googleMapIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 36)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 10)
            Spacer()
            VStack(spacing: 12) {
                Text(listing?.title ?? "")
                    .font(.abel(size: 24))
                Text(listing?.city ?? "")
                    .font(.abel(size: 14))
                Text(listing?.price ?? "")
                    .font(.abel(size: 20))
                
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal)
    }
    
    @ViewBuilder func Subsections() -> some View {
        VStack(spacing: 33) {
            VStack {
                HStack {
                    Text("Space")
                    Spacer()
                    Text("\(listing?.totalSquareMeters ?? 0)")
                }
                Divider()
                HStack {
                    Text("Interface")
                    Spacer()
                    Text(listing?.realEstateType ?? "")
                }
                Divider()
                HStack {
                    Text("Street view")
                    Spacer()
                    Text(listing?.facing ?? "")
                }
                Divider()
                HStack {
                    Text("Villa type")
                    Spacer()
                    Text(listing?.villaType ?? "")
                }
                Divider()
                HStack {
                    Text("Floor number")
                    Spacer()
                    Text("\(listing?.floorNumber ?? 0)")
                }
                Divider()
                HStack {
                    Text("Usage")
                    Spacer()
                    Text(listing?.intendedUse ?? "")
                }
                Divider()
                HStack {
                    Text("Age of the property")
                    Spacer()
                    Text("\(listing?.realEstateAge ?? 1)")
                }
                Divider()
                HStack {
                    Text("Bedrooms")
                    Spacer()
                    Text("\(listing?.bedroomCount ?? 1)")
                }
                Divider()
                HStack {
                    Text("Toilets")
                    Spacer()
                    Text("\(listing?.bathroomCount ?? 1)")
                }
                Divider()
                HStack {
                    Text("Halls and councils")
                    Spacer()
                    Text("\(listing?.livingRoomCount ?? 1)")
                }
                Divider()
                HStack {
                    Text("Number of floors")
                    Spacer()
                    Text("\(listing?.availableFloors ?? 1)")
                }
                Divider()
                HStack {
                    Text("Price per meter")
                    Spacer()
                    Text(listing?.price ?? "")
                }
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder func Features() -> some View {
        VStack(alignment: .leading) {
            Text("Features:")
                .font(.abel(size: 20))
                .fontWeight(.bold)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(listing?.extraFeaturesArray ?? [], id: \.self) { feature in
                    Text(feature)
                        .frame(width: 101, height: 36)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: 1)
                        }
                }
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder func Description() -> some View {
        VStack(alignment: .leading) {
            Text("Description:")
                .font(.abel(size: 20))
                .fontWeight(.bold)
            Text(listing?.description ?? "")
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 122)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.black, lineWidth: 1)
                }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder func AdditionalInfo() -> some View {
        VStack(alignment: .leading) {
            Text("Additional information:")
                .font(.abel(size: 24))
            VStack {
                HStack {
                    Text("Advertiser's characteristic")
                    Spacer()
                    Text("\(listing?.advertiserDescription ?? "")")
                }
                Divider()
                HStack {
                    Text("Scheme number")
                    Spacer()
                    Text(listing?.schemeNumber ?? "")
                }
                Divider()
                HStack {
                    Text("Part number")
                    Spacer()
                    Text(listing?.partNumber ?? "")
                }
                Divider()
                HStack {
                    Text("Val license number")
                    Spacer()
                    Text(listing?.valLicenseNumber ?? "")
                }
                Divider()
                HStack {
                    Text("Advertising license number")
                    Spacer()
                    Text("\(listing?.advertisingLicenseNumber ?? "")")
                }
                Divider()
                HStack {
                    Text("Display number")
                    Spacer()
                    Text("\(listing?.schemeNumber ?? "")")
                }
                Divider()
            }
            .font(.abel(size: 12))
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder func Services() -> some View {
        VStack(alignment: .leading) {
            Text("Services:")
                .font(.abel(size: 20))
                .fontWeight(.bold)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(listing?.servicesArray ?? [], id: \.self) { service in
                    Text(service)
                        .font(.abel(size: 15))
                        .frame(width: 101, height: 36)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: 1)
                        }
                }
            }
        }
        .padding(.horizontal)
    }
}
