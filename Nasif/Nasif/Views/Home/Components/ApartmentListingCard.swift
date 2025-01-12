//
//  ApartmentListingCard.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 09/01/25.
//

import SwiftUI

struct ApartmentListingCard: View {
    
    var title: String
    var location: String
    var price: Int
    var image: String
    
    var bathrooms: Int
    var bedrooms: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
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
                Spacer()
                VStack(alignment: .trailing) {
                    Text(title)
                        .font(.abel(size: 22))
                }
            }
            .padding(12)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            Color.gray.opacity(0.2)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    ApartmentListingCard(title: "villa for sale", location: "Riyadh, Al-Ghadeer district", price: 300, image: "", bathrooms: 2, bedrooms: 4)
        .padding(.horizontal)
}
