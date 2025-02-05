//
//  PuLIstingView.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 04/02/25.
//

import SwiftUI

struct ListingAddResponse: Codable {
    var message: String?
}

@MainActor
class ListingAddViewModel: ObservableObject {
    
    @Published var realEstateType: String? = nil
    @Published var apartmnetName: String? = nil
    @Published var apartmnetPrice: Int? = nil
    @Published var apartmentTotalMetres: Int? = nil
    @Published var apartmentAge: Int? = nil
    @Published var streetWidth: Int? = nil
    @Published var apartmentFacingSide: String? = nil
    @Published var apartmentNumberOfStreets: Int? = nil
    @Published var apartmentCity: String? = nil
    @Published var apartmentNeightbourHood: String? = nil
    @Published var apartmentLatitude: Double? = nil
    @Published var apartmentLongitude: Double? = nil
    @Published var apartmentMainImageUrl: String? = nil
    @Published var apartmentAdditionaImages: [String]? = nil
    @Published var additionalVideoUrl: String? = nil
    @Published var advertiserDescription: String? = nil
    @Published var schemeNumber: String? = nil
    @Published var aparmentPartNumber: String? = nil
    @Published var valLicenceNumber: String? = nil
    @Published var advertisingLicenceNumber: String? = nil
    @Published var description: String? = nil
    @Published var availability: Int? = nil
    @Published var villaType: String? = nil
    @Published var intendedUse: String? = nil
    @Published var floorNumber: Int? = nil
    @Published var availableFloors: Int? = nil
    @Published var bedroomCount: Int? = nil
    @Published var bathroomCount: Int? = nil
    @Published var livingRoomCount: Int? = nil
    @Published var seatingAreaCount: Int? = nil
    @Published var availableParking: Bool? = nil
    @Published var services: [String]? = nil
    @Published var extraFeatures: [String]? = nil
    
    @Published var listingResponse: ListingAddResponse?
    @Published var isListingLoading: Bool = false
    
    let userId: Int? = {
        return UserDefaults.standard.integer(forKey: "userId")
    }()
    
    init() {
        //        sendListings()
    }
    
    func sendListings() {
        isListingLoading = true
        Task {
            do {
                let response = try await APIClient.shared.callWithStatusCode(.sendListing(userId: 1/* ?? 0*/, realEstateType: realEstateType ?? "", apartmnetName: apartmnetName ?? "", apartmnetPrice: apartmnetPrice ?? 0, apartmentTotalMetres: apartmentTotalMetres ?? 0, apartmentAge: apartmentAge ?? 0, streetWidth: streetWidth ?? 0, apartmentFacingSide: apartmentFacingSide ?? "", apartmentNumberOfStreets: apartmentNumberOfStreets ?? 0, apartmentCity: apartmentCity ?? "", apartmentNeightbourHood: apartmentNeightbourHood ?? "", apartmentLatitude: apartmentLatitude ?? 0, apartmentLongitude: apartmentLongitude ?? 0, apartmentMainImageUrl: apartmentMainImageUrl ?? "", apartmentAdditionaImages: apartmentAdditionaImages ?? [], additionalVideoUrl: additionalVideoUrl ?? "", advertiserDescription: advertiserDescription ?? "", schemeNumber: schemeNumber ?? "", aparmentPartNumber: aparmentPartNumber ?? "", valLicenceNumber: valLicenceNumber ?? "", advertisingLicenceNumber: advertisingLicenceNumber ?? "", description: description ?? "", availability: availability ?? 1, villaType: villaType ?? "", intendedUse: intendedUse ?? "", floorNumber: floorNumber ?? 0, availableFloors: availableFloors ?? 0, bedroomCount: bedroomCount ?? 0, bathroomCount: bathroomCount ?? 0, livingRoomCount: livingRoomCount ?? 0, seatingAreaCount: seatingAreaCount ?? 0, availableParking: availableParking ?? true, services: services ?? [], extraFeatures: extraFeatures ?? []), decodeTo: ListingAddResponse.self)
                DispatchQueue.main.async {
                    self.listingResponse = response.data
                    self.isListingLoading = false
                    print("success in sending listing: \(response)")
                }
            } catch {
                isListingLoading = false
                print("error in sending listing: \(error)")
                print(error.localizedDescription)
            }
        }
    }
}

struct ListingAddView: View {
    
    @StateObject var viewModel = ListingAddViewModel()
    
    @State var filteredSections = 3
    let totalSections = 10
    
    
    @State var selectedStatus: String? = ""
    @State var priceString: String = ""
    @State var metreAreaString: String = ""
    
    var body: some View {
        ScrollView {
            VStack {
                ApartmentStatus()
                PropertyTypes()
                PriceArea()
            }
            .padding()
        }
        .apply { content in
            if #available(iOS 16.0, *) {
                content.toolbarRole(.editor)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("New offer")
                        .font(.abel(size: 20))
                    Rectangle()
                        .fill(.accent)
                        .frame(width: CGFloat(filteredSections) / CGFloat(totalSections) * 300, height: 4)
                        .cornerRadius(2)
                        .animation(.easeInOut(duration: 0.3), value: filteredSections)
                }
            }
        }
    }
    
    @ViewBuilder func ApartmentStatus() -> some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Display condition:")
                    .font(.abel(size: 20))
                    .fontWeight(.bold)
                HStack {
                    Button {
                        viewModel.availability = 1
                    } label: {
                        Text("Available")
                            .foregroundStyle(viewModel.availability == 1 ? .white : .gray)
                            .frame(width: 90, height: 36)
                            .background {
                                if viewModel.availability == 1 {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.accent)
                                } else {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.gray, lineWidth: 1)
                                }
                            }
                            .tint(.gray)
                    }
                    
                    Button {
                        viewModel.availability = 2
                    } label: {
                        Text("Reserved")
                            .foregroundStyle(viewModel.availability == 2 ? .white : .gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(width: 90, height: 36)
                            .background {
                                if viewModel.availability == 2  {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.accent)
                                } else {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.gray, lineWidth: 1)
                                }
                            }
                            .tint(.gray)
                    }
                    
                    Button {
                        viewModel.availability = 3
                    } label: {
                        Text("Sold")
                            .foregroundStyle(viewModel.availability == 3 ? .white : .gray)
                            .frame(width: 90, height: 36)
                            .background {
                                if viewModel.availability == 3  {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.accent)
                                } else {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.gray, lineWidth: 1)
                                }
                            }
                            .tint(.gray)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder func PropertyTypes() -> some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Display condition:")
                    .font(.abel(size: 20))
                    .fontWeight(.bold)
                HStack {
                    Button {
                        viewModel.realEstateType = "Studio"
                    } label: {
                        Text("Studio")
                            .foregroundStyle(viewModel.availability == 1 ? .white : .gray)
                            .frame(width: 77, height: 36)
                            .background {
                                if viewModel.availability == 1 {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.accent)
                                } else {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.gray, lineWidth: 1)
                                }
                            }
                            .tint(.gray)
                    }
                    
                    Button {
                        viewModel.realEstateType = "Apartment"
                    } label: {
                        Text("Reserved")
                            .foregroundStyle(viewModel.availability == 2 ? .white : .gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(width: 77, height: 36)
                            .background {
                                if viewModel.availability == 2  {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.accent)
                                } else {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.gray, lineWidth: 1)
                                }
                            }
                            .tint(.gray)
                    }
                    
                    Button {
                        viewModel.realEstateType = "Apartment"
                    } label: {
                        Text("Apartment")
                            .foregroundStyle(viewModel.availability == 3 ? .white : .gray)
                            .frame(width: 77, height: 36)
                            .background {
                                if viewModel.availability == 3  {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.accent)
                                } else {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.gray, lineWidth: 1)
                                }
                            }
                            .tint(.gray)
                    }
                }
                HStack {
                    Button {
                        viewModel.realEstateType = "Apartment"
                    } label: {
                        Text("Apartment")
                            .foregroundStyle(viewModel.availability == 1 ? .white : .gray)
                            .frame(width: 77, height: 36)
                            .background {
                                if viewModel.availability == 1 {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.accent)
                                } else {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.gray, lineWidth: 1)
                                }
                            }
                            .tint(.gray)
                    }
                    
                    Button {
                        viewModel.realEstateType = "Apartment"
                    } label: {
                        Text("Apartment")
                            .foregroundStyle(viewModel.availability == 2 ? .white : .gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(width: 77, height: 36)
                            .background {
                                if viewModel.availability == 2  {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.accent)
                                } else {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.gray, lineWidth: 1)
                                }
                            }
                            .tint(.gray)
                    }
                    
                    Button {
                        viewModel.realEstateType = "Apartment"
                    } label: {
                        Text("Apartment")
                            .foregroundStyle(viewModel.availability == 3 ? .white : .gray)
                            .frame(width: 77, height: 36)
                            .background {
                                if viewModel.availability == 3  {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.accent)
                                } else {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.gray, lineWidth: 1)
                                }
                            }
                            .tint(.gray)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder func PriceArea() -> some View {
        VStack(alignment: .leading) {
            Text("Price:")
                .font(.abel(size: 20))
                .fontWeight(.bold)
            
            TextField("SAR", text: $priceString, onEditingChanged: { isEditing in
                if isEditing {
                    filteredSections += 1
                } else {
                    filteredSections -= 1
                    priceString = "\(viewModel.apartmnetPrice ?? 0)"
                }
            })
        }
        
        VStack(alignment: .leading) {
            Text("Area:")
                .font(.abel(size: 20))
                .fontWeight(.bold)
            
            TextField("SAR", text: Binding(
                           get: {
                               String(viewModel.apartmentTotalMetres ?? 0)
                           },
                           set: {
                               if let newValue = Int($0) {
                                   viewModel.apartmentTotalMetres = newValue
                               }
                           }
            ), onEditingChanged: { isEditing in
                if isEditing {
                    filteredSections += 1
                } else {
                    filteredSections -= 1
                }
            })
        }
    }
    
    @ViewBuilder func NewToggles() -> some View {
        VStack {
            Text("Age of the property:")
                .font(.abel(size: 20))
                .fontWeight(.bold)
            
        }
    }
}

#Preview {
    ListingAddView()
}
