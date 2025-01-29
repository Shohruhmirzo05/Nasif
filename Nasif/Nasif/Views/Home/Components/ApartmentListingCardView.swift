//
//  ApartmentListingCard.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 09/01/25.
//

import SwiftUI

struct Attribute: Identifiable {
    var id = UUID()
    var type: String
    var value: String
}

struct ApartmentListingCardView: View {
    @Environment(\.layoutDirection) var layoutDirection: LayoutDirection
    
    let listing: Listing
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                ImageSection()
                Spacer()
                VStack(alignment: layoutDirection == .leftToRight ? .trailing : .leading, spacing: 16) {
                    Text(listing.title ?? "Unknown Title")
                        .font(.abel(size: 15))
                    Text("\(listing.city ?? "Unknown City"), \(listing.neighborhood ?? "Unknown Neighborhood")")
                        .font(.abel(size: 10))
                    HStack {
                        Text("\(listing.bedroomCount ?? 0)")
                            .frame(width: 55, height: 27)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        Text("\(listing.bathroomCount ?? 0)")
                            .frame(width: 55, height: 27)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        Text("\(listing.totalSquareMeters ?? 0)")
                            .frame(width: 55, height: 27)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .font(.abel(size: 10))
                    HStack {
                        Text("Riyal")
                        Text(listing.price ?? "0")
                    }
                    .font(.abel(size: 16))
                    .foregroundStyle(.accent)
                }
            }
            .padding(12)
        }
        .tint(.black)
        .frame(maxWidth: .infinity, alignment: layoutDirection == .leftToRight ? .leading : .trailing)
        .background {
            Color.gray.opacity(0.2)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    @ViewBuilder func ImageSection() -> some View {
        Group {
            if let image = listing.mainImageURL {
                CachedImage(imageUrl: image)
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                    .border(.red)
                    .background {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 48, height: 48)
                            .foregroundStyle(.gray)
                    }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .padding(50)
                    .background {
                        Color.black.opacity(0.3)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
            }
        }
        .overlay {
            VStack {
                if listing.availability == 1 {
                    Text("Available")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color(hex: "#287346"))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .offset(y: -4)
                    Spacer()
                } else if listing.availability == 2 {
                    Text("Sold")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color(hex: "#C50000"))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .offset(y: -4)
                    Spacer()
                } else if listing.availability == 3 {
                    Text("Reserved")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color(hex: "#7A12E9"))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .offset(y: -4)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}

