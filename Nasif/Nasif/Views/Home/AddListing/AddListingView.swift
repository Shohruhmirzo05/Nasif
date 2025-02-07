//
//  PuLIstingView.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 04/02/25.
//

import SwiftUI
import GoogleMaps

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
    @Published var floorNumber: Int = 1
    @Published var availableFloors: Int = 1
    @Published var bedroomCount: Int = 1
    @Published var bathroomCount: Int = 1
    @Published var livingRoomCount: Int = 1
    @Published var seatingAreaCount: Int = 1
    @Published var availableParking: Bool? = nil
    @Published var services: [String] = []
    @Published var extraFeatures: [String] = []
    
    @Published var listingResponse: ListingAddResponse?
    @Published var isListingLoading: Bool = false
    
    @State var cllocation: CLLocationCoordinate2D? = nil
    @State var showPin: Bool = false
    @State var longitude: Double = 0.0
    @State var latitude: Double = 0.0
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
                let response = try await APIClient.shared.callWithStatusCode(.sendListing(userId: 1/* ?? 0*/, realEstateType: realEstateType ?? "", apartmnetName: apartmnetName ?? "", apartmnetPrice: apartmnetPrice ?? 0, apartmentTotalMetres: apartmentTotalMetres ?? 0, apartmentAge: apartmentAge ?? 0, streetWidth: streetWidth ?? 0, apartmentFacingSide: apartmentFacingSide ?? "", apartmentNumberOfStreets: apartmentNumberOfStreets ?? 0, apartmentCity: apartmentCity ?? "", apartmentNeightbourHood: apartmentNeightbourHood ?? "", apartmentLatitude: apartmentLatitude ?? 0, apartmentLongitude: apartmentLongitude ?? 0, apartmentMainImageUrl: apartmentMainImageUrl ?? "", apartmentAdditionaImages: apartmentAdditionaImages ?? [], additionalVideoUrl: additionalVideoUrl ?? "", advertiserDescription: advertiserDescription ?? "", schemeNumber: schemeNumber ?? "", aparmentPartNumber: aparmentPartNumber ?? "", valLicenceNumber: valLicenceNumber ?? "", advertisingLicenceNumber: advertisingLicenceNumber ?? "", description: description ?? "", availability: availability ??  1, villaType: villaType ?? "", intendedUse: intendedUse ?? "", floorNumber: floorNumber, availableFloors: availableFloors, bedroomCount: bedroomCount, bathroomCount: bathroomCount, livingRoomCount: livingRoomCount, seatingAreaCount: seatingAreaCount, availableParking: availableParking ?? true, services: services, extraFeatures: extraFeatures), decodeTo: ListingAddResponse.self)
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
    
    @State var showNextView: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                ApartmentStatus()
                PropertyTypes()
                PriceArea()
                NewToggles()
                VillaType()
                Usage()
                Floors()
                Services()
                AdditionalFeatures()
                MainButton("Next") {
                    showNextView = true
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            NavigationLink(destination: ChooseLocationView(), isActive: $showNextView) {
                EmptyView()
            }
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
    
    //MARK: ApartmentStatus
    @ViewBuilder func ApartmentStatus() -> some View {
        VStack(alignment: .leading) {
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
                            .frame(maxWidth: .infinity)
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
                            .frame(maxWidth: .infinity)
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
                            .frame(maxWidth: .infinity)
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
    
    //MARK: PropertyTypes
    @ViewBuilder func PropertyTypes() -> some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Property type:")
                    .font(.abel(size: 20))
                    .fontWeight(.bold)
                HStack {
                    Button {
                        viewModel.realEstateType = "Studio"
                    } label: {
                        Text("Studio")
                            .foregroundStyle(viewModel.realEstateType == "Studio" ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(width: 80, height: 36)
                            .background {
                                if viewModel.realEstateType == "Studio" {
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
                        viewModel.realEstateType = "apartment"
                    } label: {
                        Text("apartment")
                            .foregroundStyle(viewModel.realEstateType == "apartment" ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(width: 80, height: 36)
                            .background {
                                if viewModel.realEstateType == "apartment" {
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
                        viewModel.realEstateType = "villa"
                    } label: {
                        Text("villa")
                            .foregroundStyle(viewModel.realEstateType == "villa" ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(width: 80, height: 36)
                            .background {
                                if viewModel.realEstateType == "villa"  {
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
                        viewModel.realEstateType = "land"
                    } label: {
                        Text("land")
                            .foregroundStyle(viewModel.realEstateType == "land" ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(width: 80, height: 36)
                            .background {
                                if viewModel.realEstateType == "land"  {
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
                        viewModel.realEstateType = "Other"
                    } label: {
                        Text("Other")
                            .foregroundStyle(viewModel.realEstateType == "Other" ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(width: 80, height: 36)
                            .background {
                                if viewModel.realEstateType == "Other" {
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
                        viewModel.realEstateType = "farm"
                    } label: {
                        Text("farm")
                            .foregroundStyle(viewModel.realEstateType == "farm" ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(width: 80, height: 36)
                            .background {
                                if viewModel.realEstateType == "farm" {
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
                        viewModel.realEstateType = "break"
                    } label: {
                        Text("break")
                            .foregroundStyle(viewModel.realEstateType == "break" ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(width: 80, height: 36)
                            .background {
                                if viewModel.realEstateType == "break"  {
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
                        viewModel.realEstateType = "architecture"
                    } label: {
                        Text("architecture")
                            .foregroundStyle(viewModel.realEstateType == "architecture" ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(width: 80, height: 36)
                            .background {
                                if viewModel.realEstateType == "architecture"  {
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
    
    //MARK: PriceArea
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
            .keyboardType(.numberPad)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, lineWidth: 1)
            }
        }
        .padding(.horizontal, 24)
        
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
            .keyboardType(.numberPad)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, lineWidth: 1)
            }
        }
        .padding(.horizontal, 24)
    }
    
    //MARK: NewToggles
    @ViewBuilder func NewToggles() -> some View {
        VStack {
            Text("Age of the property:")
                .font(.abel(size: 20))
                .fontWeight(.bold)
            HStack {
                TextField("m", text: Binding(
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
                .frame(width: 120)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 1)
                }
                Text("north")
            }
            HStack {
                TextField("m", text: Binding(
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
                .frame(width: 120)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 1)
                }
                Text("east")
            }
            HStack {
                TextField("m", text: Binding(
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
                .frame(width: 120)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 1)
                }
                Text("west")
            }
            HStack {
                TextField("m", text: Binding(
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
                .frame(width: 120)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 1)
                }
                Text("south")
            }
        }
        .font(.abel(size: 15))
    }
    
    //MARK: Villatype
    @ViewBuilder func VillaType() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Villa Type")
                .font(.abel(size: 20))
            HStack {
                Button {
                    viewModel.villaType = "Independent"
                } label: {
                    Text("Independent")
                        .foregroundStyle(viewModel.villaType == "Independent" ? .white : .gray)
                        .frame(maxWidth: .infinity)
                        .frame(width: 90, height: 36)
                        .background {
                            if viewModel.villaType == "Independent"  {
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
                    viewModel.villaType = "Duplex"
                } label: {
                    Text("Duplex")
                        .foregroundStyle(viewModel.villaType == "Duplex" ? .white : .gray)
                        .frame(maxWidth: .infinity)
                        .frame(width: 90, height: 36)
                        .background {
                            if viewModel.villaType == "Duplex"  {
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
                    viewModel.villaType = "Townhouse"
                } label: {
                    Text("Townhouse")
                        .foregroundStyle(viewModel.villaType == "Townhouse" ? .white : .gray)
                        .frame(maxWidth: .infinity)
                        .frame(width: 90, height: 36)
                        .background {
                            if viewModel.villaType == "Townhouse"  {
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
            .padding(.horizontal, 24)
        }
    }
    
    //MARK: Usage
    @ViewBuilder func Usage() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Intended usage")
                .font(.abel(size: 20))
            HStack {
                Button {
                    viewModel.intendedUse = "Raw"
                } label: {
                    Text("Raw")
                        .foregroundStyle(viewModel.intendedUse == "Raw" ? .white : .gray)
                        .frame(maxWidth: .infinity)
                        .frame(width: 80, height: 36)
                        .background {
                            if viewModel.intendedUse == "Raw"  {
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
                    viewModel.intendedUse = "agricultural"
                } label: {
                    Text("agricultural")
                        .foregroundStyle(viewModel.intendedUse == "agricultural" ? .white : .gray)
                        .frame(maxWidth: .infinity)
                        .frame(width: 80, height: 36)
                        .background {
                            if viewModel.intendedUse == "agricultural"  {
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
                    viewModel.intendedUse = "commercial"
                } label: {
                    Text("commercial")
                        .foregroundStyle(viewModel.intendedUse == "commercial" ? .white : .gray)
                        .frame(maxWidth: .infinity)
                        .frame(width: 80, height: 36)
                        .background {
                            if viewModel.intendedUse == "commercial"  {
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
                    viewModel.intendedUse = "residential"
                } label: {
                    Text("residential")
                        .foregroundStyle(viewModel.intendedUse == "residential" ? .white : .gray)
                        .frame(maxWidth: .infinity)
                        .frame(width: 80, height: 36)
                        .background {
                            if viewModel.intendedUse == "residential"  {
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
            .padding(.horizontal)
        }
    }
    
    //MARK: Floors
    @ViewBuilder func Floors() -> some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Floor number:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.abel(size: 20))
                HStack(spacing: 24) {
                    Button {
                        viewModel.floorNumber -= 1
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.accent)
                            .frame(width: 40, height: 32)
                            .overlay {
                                Text("-")
                                    .font(.title)
                                    .foregroundStyle(.white)
                            }
                    }
                    Text("\(viewModel.floorNumber)")
                        .font(.abel(size: 24))
                    Button {
                        viewModel.floorNumber += 1
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.accent)
                            .frame(width: 40, height: 32)
                            .overlay {
                                Text("+")
                                    .font(.title)
                                    .foregroundStyle(.white)
                            }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            VStack(alignment: .leading, spacing: 10) {
                Text("Number of floors:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.abel(size: 20))
                HStack(spacing: 24) {
                    Button {
                        viewModel.availableFloors -= 1
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.accent)
                            .frame(width: 40, height: 32)
                            .overlay {
                                Text("-")
                                    .font(.title)
                                    .foregroundStyle(.white)
                            }
                    }
                    Text("\(viewModel.availableFloors)")
                        .font(.abel(size: 24))
                    Button {
                        viewModel.availableFloors += 1
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.accent)
                            .frame(width: 40, height: 32)
                            .overlay {
                                Text("+")
                                    .font(.title)
                                    .foregroundStyle(.white)
                            }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            VStack(alignment: .leading, spacing: 10) {
                Text("Number of bedrooms:")
                    .font(.abel(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: 24) {
                    Button {
                        viewModel.bedroomCount -= 1
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.accent)
                            .frame(width: 40, height: 32)
                            .overlay {
                                Text("-")
                                    .font(.title)
                                    .foregroundStyle(.white)
                            }
                    }
                    Text("\(viewModel.bedroomCount)")
                        .font(.abel(size: 24))
                    Button {
                        //                    viewModel.bedroomCount += 1
                        self.viewModel.bedroomCount += 1
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.accent)
                            .frame(width: 40, height: 32)
                            .overlay {
                                Text("+")
                                    .font(.title)
                                    .foregroundStyle(.white)
                            }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            VStack(alignment: .leading, spacing: 10) {
                Text("Number of bathrooms:")
                    .font(.abel(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: 24) {
                    Button {
                        viewModel.bathroomCount -= 1
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.accent)
                            .frame(width: 40, height: 32)
                            .overlay {
                                Text("-")
                                    .font(.title)
                                    .foregroundStyle(.white)
                            }
                    }
                    Text("\(viewModel.bathroomCount)")
                        .font(.abel(size: 24))
                    Button {
                        viewModel.bathroomCount += 1
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.accent)
                            .frame(width: 40, height: 32)
                            .overlay {
                                Text("+")
                                    .font(.title)
                                    .foregroundStyle(.white)
                            }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            VStack(alignment: .leading, spacing: 10) {
                Text("Number of halls and sitting areas:")
                    .font(.abel(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: 24) {
                    Button {
                        viewModel.seatingAreaCount -= 1
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.accent)
                            .frame(width: 40, height: 32)
                            .overlay {
                                Text("-")
                                    .font(.title)
                                    .foregroundStyle(.white)
                            }
                    }
                    Text("\(viewModel.seatingAreaCount )")
                        .font(.abel(size: 24))
                    Button {
                        viewModel.seatingAreaCount += 1
                    } label: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.accent)
                            .frame(width: 40, height: 32)
                            .overlay {
                                Text("+")
                                    .font(.title)
                                    .foregroundStyle(.white)
                            }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
        //        VStack(alignment: .leading, spacing: 10) {
        //            Text("Number of parking spaces:")
        //                .font(.abel(size: 20))
        //            HStack {
        //                Button {
        //                    viewModel.availableParking! -= 1
        //                } label: {
        //                    RoundedRectangle(cornerRadius: 8)
        //                        .fill(.accent)
        //                        .overlay {
        //                            Text("-")
        //                                .font(.title)
        //                                .foregroundStyle(.white)
        //                        }
        //                }
        //                Text("\(viewModel.availableParking ?? 0)")
        //                    .font(.abel(size: 24))
        //                Button {
        //                    viewModel.availableParking! += 1
        //                } label: {
        //                    RoundedRectangle(cornerRadius: 8)
        //                        .fill(.accent)
        //                        .overlay {
        //                            Text("+")
        //                                .font(.title)
        //                                .foregroundStyle(.white)
        //                        }
        //                }
        //            }
        //        }
    }
    
    //MARK: Services
    @ViewBuilder func Services() -> some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Services:")
                    .font(.abel(size: 20))
                    .fontWeight(.bold)
                HStack {
                    Button {
                        if viewModel.services.contains("Sanitation") {
                            viewModel.services.removeAll { $0 == "Sanitation" }
                        } else {
                            viewModel.services.append("Sanitation")
                        }
                    } label: {
                        Text("Sanitation")
                            .foregroundStyle(viewModel.services.contains("Sanitation") ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(width: 100, height: 36)
                            .background {
                                if viewModel.services.contains("Sanitation") {
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
                        if viewModel.services.contains("electricity") {
                            viewModel.services.removeAll { $0 == "electricity" }
                        } else {
                            viewModel.services.append("electricity")
                        }
                    } label: {
                        Text("electricity")
                            .foregroundStyle(viewModel.services.contains("electricity") ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(width: 100, height: 36)
                            .background {
                                if viewModel.services.contains("electricity") {
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
                        if viewModel.services.contains("waters") {
                            viewModel.services.removeAll { $0 == "waters" }
                        } else {
                            viewModel.services.append("waters")
                        }
                    } label: {
                        Text("waters")
                            .foregroundStyle(viewModel.services.contains("waters") ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(width: 100, height: 36)
                            .background {
                                if viewModel.services.contains("waters") {
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
                        if viewModel.services.contains("Seoul drainage") {
                            viewModel.services.removeAll { $0 == "Seoul drainage" }
                        } else {
                            viewModel.services.append("Seoul drainage")
                        }
                    } label: {
                        Text("Seoul drainage")
                            .foregroundStyle(viewModel.services.contains("Seoul drainage") ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(width: 100, height: 36)
                            .background {
                                if viewModel.services.contains("Seoul drainage") {
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
                        if viewModel.services.contains("phone") {
                            viewModel.services.removeAll { $0 == "phone" }
                        } else {
                            viewModel.services.append("phone")
                        }
                    } label: {
                        Text("phone")
                            .foregroundStyle(viewModel.services.contains("phone") ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(width: 100, height: 36)
                            .background {
                                if viewModel.services.contains("phone") {
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
                        if viewModel.services.contains("Optical fiber") {
                            viewModel.services.removeAll { $0 == "Optical fiber" }
                        } else {
                            viewModel.services.append("Optical fiber")
                        }
                    } label: {
                        Text("Optical fiber")
                            .foregroundStyle(viewModel.services.contains("Optical fiber") ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(width: 100, height: 36)
                            .background {
                                if viewModel.services.contains("Optical fiber") {
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
    
    //MARK: Additional Features
    @ViewBuilder func AdditionalFeatures() -> some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Additional features:")
                    .font(.abel(size: 20))
                    .fontWeight(.bold)
                HStack {
                    Button {
                        if viewModel.extraFeatures.contains("kitchen") {
                            viewModel.extraFeatures.removeAll { $0 == "kitchen" }
                        } else {
                            viewModel.extraFeatures.append("kitchen")
                        }
                    } label: {
                        Text("kitchen")
                            .foregroundStyle(viewModel.extraFeatures.contains("kitchen") ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(width: 100, height: 36)
                            .background {
                                if viewModel.extraFeatures.contains("kitchen") {
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
                        if viewModel.extraFeatures.contains("Air conditioners") {
                            viewModel.extraFeatures.removeAll { $0 == "Air conditioners" }
                        } else {
                            viewModel.extraFeatures.append("Air conditioners")
                        }
                    } label: {
                        Text("Air conditioners")
                            .foregroundStyle(viewModel.extraFeatures.contains("Air conditioners") ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(width: 100, height: 36)
                            .background {
                                if viewModel.extraFeatures.contains("Air conditioners") {
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
                        if viewModel.extraFeatures.contains("Furnished") {
                            viewModel.extraFeatures.removeAll { $0 == "Furnished" }
                        } else {
                            viewModel.extraFeatures.append("Furnished")
                        }
                    } label: {
                        Text("Furnished")
                            .foregroundStyle(viewModel.extraFeatures.contains("Furnished") ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(width: 100, height: 36)
                            .background {
                                if viewModel.extraFeatures.contains("Furnished") {
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
                        if viewModel.extraFeatures.contains("Basement position") {
                            viewModel.extraFeatures.removeAll { $0 == "Basement position" }
                        } else {
                            viewModel.extraFeatures.append("Basement position")
                        }
                    } label: {
                        Text("Basement position")
                            .foregroundStyle(viewModel.extraFeatures.contains("Basement position") ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(width: 100, height: 36)
                            .background {
                                if viewModel.extraFeatures.contains("Basement position") {
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
                        if viewModel.extraFeatures.contains("Monsters") {
                            viewModel.extraFeatures.removeAll { $0 == "Monsters" }
                        } else {
                            viewModel.extraFeatures.append("Monsters")
                        }
                    } label: {
                        Text("Monsters")
                            .foregroundStyle(viewModel.extraFeatures.contains("Monsters") ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(width: 100, height: 36)
                            .background {
                                if viewModel.extraFeatures.contains("Monsters") {
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
                        if viewModel.extraFeatures.contains("surface") {
                            viewModel.extraFeatures.removeAll { $0 == "surface" }
                        } else {
                            viewModel.extraFeatures.append("surface")
                        }
                    } label: {
                        Text("surface")
                            .foregroundStyle(viewModel.extraFeatures.contains("surface") ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(width: 100, height: 36)
                            .background {
                                if viewModel.extraFeatures.contains("surface") {
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
                        if viewModel.extraFeatures.contains("Laundry room") {
                            viewModel.extraFeatures.removeAll { $0 == "Laundry room" }
                        } else {
                            viewModel.extraFeatures.append("Laundry room")
                        }
                    } label: {
                        Text("Laundry room")
                            .foregroundStyle(viewModel.extraFeatures.contains("Laundry room") ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(width: 100, height: 36)
                            .background {
                                if viewModel.extraFeatures.contains("Laundry room") {
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
                        if viewModel.extraFeatures.contains("Driver's room") {
                            viewModel.extraFeatures.removeAll { $0 == "Driver's room" }
                        } else {
                            viewModel.extraFeatures.append("Driver's room")
                        }
                    } label: {
                        Text("Driver's room")
                            .foregroundStyle(viewModel.extraFeatures.contains("Driver's room") ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(width: 100, height: 36)
                            .background {
                                if viewModel.extraFeatures.contains("Driver's room") {
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
                        if viewModel.extraFeatures.contains("Maid's room") {
                            viewModel.extraFeatures.removeAll { $0 == "Maid's room" }
                        } else {
                            viewModel.extraFeatures.append("Maid's room")
                        }
                    } label: {
                        Text("Maid's room")
                            .foregroundStyle(viewModel.extraFeatures.contains("Maid's room") ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(width: 100, height: 36)
                            .background {
                                if viewModel.extraFeatures.contains("Maid's room") {
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
                        if viewModel.extraFeatures.contains("Private entrance") {
                            viewModel.extraFeatures.removeAll { $0 == "Private entrance" }
                        } else {
                            viewModel.extraFeatures.append("Private entrance")
                        }
                    } label: {
                        Text("Private entrance")
                            .foregroundStyle(viewModel.extraFeatures.contains("Private entrance") ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(width: 100, height: 36)
                            .background {
                                if viewModel.extraFeatures.contains("Private entrance") {
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
                        if viewModel.extraFeatures.contains("complex") {
                            viewModel.extraFeatures.removeAll { $0 == "complex" }
                        } else {
                            viewModel.extraFeatures.append("complex")
                        }
                    } label: {
                        Text("complex")
                            .foregroundStyle(viewModel.extraFeatures.contains("complex") ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(width: 100, height: 36)
                            .background {
                                if viewModel.extraFeatures.contains("complex") {
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
                        if viewModel.extraFeatures.contains("Balcony") {
                            viewModel.extraFeatures.removeAll { $0 == "Balcony" }
                        } else {
                            viewModel.extraFeatures.append("Balcony")
                        }
                    } label: {
                        Text("Balcony")
                            .foregroundStyle(viewModel.extraFeatures.contains("Balcony") ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .frame(width: 100, height: 36)
                            .background {
                                if viewModel.extraFeatures.contains("Balcony") {
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
}

#Preview {
    ListingAddView()
}
