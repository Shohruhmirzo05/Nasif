//
//  SearchView.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 13/01/25.
//

import SwiftUI

struct ApartmentSearchView: View {
    
    @State var DisplayNumberSearch: String = ""
    @State var searchCity: String = ""
    @State var searchNeighbourhood: String = ""
    
    
    @State var layoutDirection: LayoutDirection = .leftToRight
    
    // Property Types
    var propertyTypes: [String] = ["land", "apartment", "house", "office", "shop", "firm", "other"]
    @State var selectedPropertyType: String = ""
    
    func propertyTypeSelected(_ propertyType: String) {
        selectedPropertyType = propertyType
    }
    
    // Interfaces
    var interfaces: [String] = ["South", "West", "North", "East"]
    @State var selectedInterface: String = ""
    
    func interfaceSelected(_ interface: String) {
        selectedInterface = interface
    }
    
    // Number of street
    var numberOfStreet: [Int] = [1, 2, 3, 4]
    @State var selectedNumberOfStreet: Int = 0
    
    func numberOfStreetSelected(_ numberOfStreet: Int) {
        selectedNumberOfStreet = numberOfStreet
    }
    
    @State var costRangeMin: String = ""
    @State var costRangeMax: String = ""
    
    @State var areaRangeMin: String = ""
    @State var areaRangeMax: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    SearchInputs()
                    PropertyType()
                    CostRangeSection()
                    AreaRange()
                    Interface()
                    NumberOfstreet()
                    AgeOfProperty()
                    VillaType()
                    LandType()
                    FloorNumber()
                    NumberOfFloors()
                    NumberOfBedrooms()
                    NumberOfBathrooms()
                    NumberOfHalls()
                    NumberOfParkingSpaces()
                    AdditionalFeatures()
                    DisplayCondition()
                }
                .padding(.vertical)
                .padding(.horizontal, 24)
            }
            .safeAreaInset(edge: .top) {
                Text("Search")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
            }
        }
        .environment(\.layoutDirection, layoutDirection)
    }
    
    //MARK: Search Inputs
    @ViewBuilder func SearchInputs() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Display Number")
                    .font(.abel(size: 15))
                TextField("Display Number", text: $DisplayNumberSearch)
                    .font(.abel(size: 15))
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .background(Color.accent.opacity(0.07))
                    .clipShape(.rect(cornerRadius: 10))
                    .foregroundColor(.black)
            }
            TextField("City", text: $searchCity)
                .font(.abel(size: 15))
                .frame(maxWidth: .infinity)
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                }
                .foregroundColor(.black)
            VStack(alignment: .leading, spacing: 8) {
                Text("Neighborhood")
                    .font(.abel(size: 15))
                TextField("everywhere", text: $searchNeighbourhood)
                    .font(.abel(size: 15))
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    }
                    .foregroundColor(.black)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    //MARK: Property Types
    @ViewBuilder func PropertyType() -> some View {
        VStack(alignment: .leading) {
            Text("Property Type")
                .font(.abel(size: 15))
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                ForEach(propertyTypes, id: \.self) { property in
                    Button {
                        withAnimation {
                            selectedPropertyType = property
                        }
                    } label: {
                        Text(property)
                            .font(.abel(size: 15))
                            .foregroundStyle(selectedPropertyType == property ? Color.accent : Color.gray)
                            .frame(width: 77, height: 36)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedPropertyType == property ? Color.accent : Color.gray, lineWidth: 1)
                            }
                    }
                }
            }
        }
    }
    
    //MARK: Cost Range
    @ViewBuilder func CostRangeSection() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Price")
                .font(.abel(size: 15))
            HStack(spacing: 16) {
                TextField("below", text: $costRangeMin)
                    .font(.abel(size: 15))
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    }
                    .keyboardType(.numberPad)
                    .foregroundColor(.black)
                Image(systemName: "minus")
                TextField("higher than", text: $costRangeMax)
                    .font(.abel(size: 15))
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    }
                    .foregroundColor(.black)
                    .keyboardType(.numberPad)
            }
            .padding(.horizontal, 24)
        }
    }
    
    // MARK: Area range
    @ViewBuilder func AreaRange() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Area m2")
                .font(.abel(size: 15))
            HStack(spacing: 16) {
                TextField("below", text: $areaRangeMin)
                    .font(.abel(size: 15))
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    }
                    .foregroundColor(.black)
                    .keyboardType(.numberPad)
                Image(systemName: "minus")
                TextField("higher than", text: $areaRangeMax)
                    .font(.abel(size: 15))
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    }
                    .foregroundColor(.black)
                    .keyboardType(.numberPad)
            }
            .padding(.horizontal, 24)
        }
    }
    
    //MARK: Interface
    @ViewBuilder func Interface() -> some View {
        VStack(alignment: .leading) {
            Text("Interface")
                .font(.abel(size: 15))
            HStack {
                ForEach(interfaces, id: \.self) { interface in
                    Button {
                        withAnimation {
                            selectedInterface = interface
                        }
                    } label: {
                        Text(interface)
                            .font(.abel(size: 15))
                            .foregroundStyle(selectedInterface == interface ? Color.accent : Color.gray)
                            .frame(width: 77, height: 36)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedInterface == interface ? Color.accent : Color.gray, lineWidth: 1)
                            }
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
    
    //MARK: Number of streets
    @ViewBuilder func NumberOfstreet() -> some View {
        VStack(alignment: .leading) {
            Text("Number of streets")
                .font(.abel(size: 15))
            HStack {
                ForEach(numberOfStreet, id: \.self) { street in
                    Button {
                        withAnimation {
                            selectedNumberOfStreet = street
                        }
                    } label: {
                        Text("\(street)")
                            .font(.abel(size: 15))
                            .foregroundStyle(selectedNumberOfStreet == street ? Color.accent : Color.gray)
                            .frame(width: 77, height: 36)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedNumberOfStreet == street ? Color.accent : Color.gray, lineWidth: 1)
                            }
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
    
    @ViewBuilder func AgeOfProperty() -> some View {
        
    }
    
    @ViewBuilder func VillaType() -> some View {
        
    }
    
    @ViewBuilder func LandType() -> some View {
        
    }
    
    @ViewBuilder func FloorNumber() -> some View {
        
    }
    
    @ViewBuilder func NumberOfFloors() -> some View {
        
    }
    
    @ViewBuilder func NumberOfBedrooms() -> some View {
        
    }
    
    @ViewBuilder func NumberOfBathrooms() -> some View {
        
    }
    
    @ViewBuilder func NumberOfHalls() -> some View {
        
    }
    
    @ViewBuilder func NumberOfParkingSpaces() -> some View {
        
    }
    
    @ViewBuilder func AdditionalFeatures() -> some View {
        
    }
    
    @ViewBuilder func DisplayCondition() -> some View {
        
    }
}

#Preview {
    ApartmentSearchView()
}
