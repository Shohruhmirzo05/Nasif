//
//  Listings.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 29/01/25.
//

import SwiftUI

struct Listing: Codable, Identifiable {
    let id: Int?
    let userID: Int?
    let realEstateType: String?
    let title: String?
    let price: String?
    let totalSquareMeters: Int?
    let realEstateAge: Int?
    let streetWidth: Int?
    let facing: String?
    let numberOfStreets: Int?
    let city: String?
    let neighborhood: String?
    let latitude: String?
    let longitude: String?
    let mainImageURL: String?
    let additionalImagesUrls: String?
    let additionalVideoURL: String?
    let advertiserDescription: String?
    let schemeNumber: String?
    let partNumber: String?
    let valLicenseNumber: String?
    let advertisingLicenseNumber, description: String?
    let availability: Int?
    let villaType: String?
    let intendedUse: String?
    let floorNumber: Int?
    let availableFloors: Int?
    let bedroomCount: Int?
    let bathroomCount: Int?
    let livingRoomCount: Int?
    let seatingAreaCount: Int??
    let availableParking: Int?
    let services: String?
    let extraFeatures: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case title, price, services, facing, description, availability, city, neighborhood, latitude, longitude
        case id = "listing_id"
        case userID = "user_id"
        case realEstateType = "real_estate_type"
        case totalSquareMeters = "total_square_meters"
        case realEstateAge = "real_estate_age"
        case streetWidth = "street_width"
        case numberOfStreets = "number_of_streets"
        case mainImageURL = "main_image_url"
        case additionalImagesUrls = "additional_images_urls"
        case additionalVideoURL = "additional_video_url"
        case advertiserDescription = "advertiser_description"
        case schemeNumber = "scheme_number"
        case partNumber = "part_number"
        case valLicenseNumber = "val_license_number"
        case advertisingLicenseNumber = "advertising_license_number"
        case villaType = "villa_type"
        case intendedUse = "intended_use"
        case floorNumber = "floor_number"
        case availableFloors = "available_floors"
        case bedroomCount = "bedroom_count"
        case bathroomCount = "bathroom_count"
        case livingRoomCount = "living_room_count"
        case seatingAreaCount = "seating_area_count"
        case availableParking = "available_parking"
        case extraFeatures = "extra_features"
        case createdAt = "created_at"
    }
    
    var additionalImagesArray: [String]? {
        guard let data = additionalImagesUrls?.data(using: .utf8) else { return nil }
        do {
            let decodedArray = try JSONDecoder().decode([String].self, from: data)
            return decodedArray
        } catch {
            print("failed to decode additionalImagesUrls string into an array: \(error)")
            return nil
        }
    }
    
    var extraFeaturesArray: [String]? {
        guard let data = extraFeatures?.data(using: .utf8) else { return nil }
        do {
            let decodedArray = try JSONDecoder().decode([String].self, from: data)
            return decodedArray
        } catch {
            print("Failed to decode extraFeatures string into an array: \(error)")
            return nil
        }
    }
    
    // A computed property to decode `services` from a string to an array of strings
    var servicesArray: [String]? {
        guard let data = services?.data(using: .utf8) else { return nil }
        do {
            let decodedArray = try JSONDecoder().decode([String].self, from: data)
            return decodedArray
        } catch {
            print("Failed to decode services string into an array: \(error)")
            return nil
        }
    }
    
    static let sampleData: [Listing] = []
    
    static let mock = Listing(id: 1, userID: 1, realEstateType: "", title: "", price: "", totalSquareMeters: 1, realEstateAge: 1, streetWidth: 1, facing: "", numberOfStreets: 1, city: "", neighborhood: "", latitude: "", longitude: "", mainImageURL: "", additionalImagesUrls: "", additionalVideoURL: "", advertiserDescription: "", schemeNumber: "", partNumber: "", valLicenseNumber: "", advertisingLicenseNumber: "", description: "", availability: 1, villaType: "", intendedUse: "", floorNumber: 1, availableFloors: 1, bedroomCount: 1, bathroomCount: 1, livingRoomCount: 1, seatingAreaCount: 1, availableParking: 1, services: "", extraFeatures: "", createdAt: "")
}


