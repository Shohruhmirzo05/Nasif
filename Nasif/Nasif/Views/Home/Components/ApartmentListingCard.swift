//
//  ApartmentListingCard.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 09/01/25.
//

import SwiftUI

struct Attribute: Identifiable {
    var id = UUID()  // Automatically create a unique ID for each attribute
    var type: String  // Type of the attribute, e.g., "Bedroom", "Bathroom"
    var value: String // Value of the attribute, e.g., "4", "2", "$300,000"
}

struct ApartmentListingCard: View {
    @Environment(\.layoutDirection) var layoutDirection: LayoutDirection
    
    var title: String
    var location: String
    var price: Int
    var image: String
    
    var sizeOfApartment: Int
    
    var bathrooms: Int
    var bedrooms: Int
    
    var status: AparmentStatus
    
    var attributes: [Attribute] 
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                ImageSection()
                Spacer()
                VStack(alignment: layoutDirection == .leftToRight ? .trailing : .leading, spacing: 16) {
                    Text(title)
                        .font(.abel(size: 15))
                    Text(location)
                        .font(.abel(size: 10))
                    HStack {
                        ForEach(attributes) { attribute in
                            Text(attribute.value)
                                .frame(width: 55, height: 27)
                                .background(Color.gray.opacity(0.3))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .font(.abel(size: 10))
                    HStack {
                        Text("Riyal")
                        Text("\(price)")
                    }
                    .font(.abel(size: 16))
                    .foregroundStyle(.accent)
                }
            }
            .padding(12)
        }
        .frame(maxWidth: .infinity, alignment: layoutDirection == .leftToRight ? .leading : .trailing)
        .background {
            Color.gray.opacity(0.2)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    @ViewBuilder func ImageSection() -> some View {
        Group {
            if !image.isEmpty {
                CachedImage(imageUrl: image)
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
                Text(status.displayText)
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                    .padding(6)
                    .background(status.displayColor)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .offset(y: -4)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}

#Preview {
    ApartmentListingCard(title: "villa for sale", location: "Riyadh, Al-Ghadeer district", price: 300, image: "", sizeOfApartment: 300, bathrooms: 2, bedrooms: 4, status: .reserved, attributes: [
        Attribute(type: "Bedroom", value: "4"),
        Attribute(type: "Bathroom", value: "2"),
        Attribute(type: "Price", value: "$300,000")
    ])
    .padding(.horizontal)
}


enum AparmentStatus {
    case available
    case sold
    case reserved
    
    var displayColor: Color {
        switch self {
        case .available: return .green
        case .sold:
            return .red
        case .reserved:
            return .indigo
        }
    }
    
    var displayText: String {
        switch self {
        case .available: return "Available"
        case .sold: return "Sold"
        case .reserved: return "Reserved"
        }
    }
}
