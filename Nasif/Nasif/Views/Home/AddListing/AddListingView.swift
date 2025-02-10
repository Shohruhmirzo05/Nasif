//
//  PuLIstingView.swift
//  Nasif
//
//  Created by Alijonov Shohruhmirzo on 04/02/25.
//

import SwiftUI
import GoogleMaps
import _PhotosUI_SwiftUI

struct ListingAddResponse: Codable {
    var message: String?
}

@MainActor
class ListingAddViewModel: ObservableObject {
    
    @Published var realEstateType: String?
    @Published var apartmnetName: String?
    @Published var apartmnetPrice: Int?
    @Published var apartmentTotalMetres: Int?
    @Published var apartmentAge: Int?
    @Published var streetWidth: Int?
    @Published var apartmentFacingSide: String?
    @Published var apartmentNumberOfStreets: Int?
    @Published var apartmentCity: String?
    @Published var apartmentNeightbourHood: String?
    @Published var apartmentLatitude: Double?
    @Published var apartmentLongitude: Double?
    
    @Published var mainImageUrl: String?
    @Published var additionalImagesUrls: [String] = []
    @Published var additionalVideoUrl: String?
    
    @Published var mainImage: UIImage?
    @Published var additionalImages: [UIImage] = []
    @Published var videoURL: URL?
    
    @Published var advertiserDescription: String?
    @Published var schemeNumber: String?
    @Published var aparmentPartNumber: String?
    @Published var valLicenceNumber: String?
    @Published var advertisingLicenceNumber: String?
    @Published var description: String?
    @Published var availability: Int?
    @Published var villaType: String?
    @Published var intendedUse: String?
    @Published var floorNumber: Int = 1
    @Published var availableFloors: Int = 1
    @Published var bedroomCount: Int = 1
    @Published var bathroomCount: Int = 1
    @Published var livingRoomCount: Int = 1
    @Published var seatingAreaCount: Int = 1
    @Published var availableParking: Bool?
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
                let (mainUrl, additionalUrls, videoUrl) = try await APIClient.shared.uploadMediaFiles(
                                  mainImage: mainImage,
                                  additionalImages: additionalImages,
                                  videoURL: videoURL
                              )
//                print("🚀 Uploading Main Image & Video...")
//                
//                let (uploadedMainImageUrl, uploadedVideoUrl) = try await APIClient.shared.uploadMedia(
//                    image: mainImage,
//                    videoURL: videoURL
//                ) { progress in
//                    print("📤 Main Media Upload Progress: \(progress * 100)%")
//                }
//                
//                print("✅ Main Image Uploaded: \(uploadedMainImageUrl ?? "None")")
//                print("✅ Video Uploaded: \(uploadedVideoUrl ?? "None")")
//                
//                // Store uploaded URLs
//                DispatchQueue.main.async {
//                    self.mainImageUrl = uploadedMainImageUrl
//                    self.additionalVideoUrl = uploadedVideoUrl
//                }
//                
//                // Step 2: Upload Additional Images
//                var uploadedImageUrls: [String] = []
//                for (index, image) in additionalImages.enumerated() {
//                    do {
//                        print("🚀 Uploading Additional Image \(index + 1)...")
//                        
//                        let (imageUrl, _) = try await APIClient.shared.uploadMedia(
//                            image: image,
//                            videoURL: nil
//                        ) { progress in
//                            print("📤 Upload Progress for Image \(index + 1): \(progress * 100)%")
//                        }
//                        
//                        if let imageUrl = imageUrl {
//                            uploadedImageUrls.append(imageUrl)
//                            print("✅ Additional Image \(index + 1) Uploaded: \(imageUrl)")
//                        } else {
//                            print("❌ Failed to upload Additional Image \(index + 1)")
//                        }
//                    } catch {
//                        print("❌ Error uploading Additional Image \(index + 1): \(error)")
//                    }
//                }
//                
//                // Store uploaded image URLs
//                DispatchQueue.main.async {
//                    self.additionalImagesUrls = uploadedImageUrls
//                }
//                
//                // ✅ Step 3: Confirm all uploads are completed
//                print("🚀 All Media Uploads Completed. Preparing to send listing...")
                
                
                // Step 4: Send Listing with Updated URLs
                let response = try await APIClient.shared.callWithStatusCode(
                    .sendListing(
                        userId: 1 /*?? 0*/,
                        realEstateType: realEstateType ?? "",
                        apartmnetName: apartmnetName ?? "",
                        apartmnetPrice: apartmnetPrice ?? 0,
                        apartmentTotalMetres: apartmentTotalMetres ?? 0,
                        apartmentAge: apartmentAge ?? 0,
                        streetWidth: streetWidth ?? 0,
                        apartmentFacingSide: apartmentFacingSide ?? "",
                        apartmentNumberOfStreets: apartmentNumberOfStreets ?? 0,
                        apartmentCity: apartmentCity ?? "",
                        apartmentNeightbourHood: apartmentNeightbourHood ?? "",
                        apartmentLatitude: apartmentLatitude ?? 0,
                        apartmentLongitude: apartmentLongitude ?? 0,
                        
                        apartmentMainImageUrl: mainUrl ?? "",
                        apartmentAdditionalImages: additionalUrls,
                        additionalVideoUrl: videoUrl ?? "",
                        
                        advertiserDescription: advertiserDescription ?? "",
                        schemeNumber: schemeNumber ?? "",
                        aparmentPartNumber: aparmentPartNumber ?? "",
                        valLicenceNumber: valLicenceNumber ?? "",
                        advertisingLicenceNumber: advertisingLicenceNumber ?? "",
                        description: description ?? "",
                        availability: availability ?? 1,
                        villaType: villaType ?? "",
                        intendedUse: intendedUse ?? "",
                        floorNumber: floorNumber,
                        availableFloors: availableFloors,
                        bedroomCount: bedroomCount,
                        bathroomCount: bathroomCount,
                        livingRoomCount: livingRoomCount,
                        seatingAreaCount: seatingAreaCount,
                        availableParking: availableParking ?? true,
                        services: services,
                        extraFeatures: extraFeatures
                    ),
                    decodeTo: ListingAddResponse.self
                )
                
                print(response.data)
                DispatchQueue.main.async {
                    self.listingResponse = response.data
                    self.isListingLoading = false
                    print("✅ Success in sending listing: \(response)")
                }
                
            } catch {
                isListingLoading = false
                print("❌ Error in sending listing: \(error.localizedDescription)")
                print(error)
            }
        }
    }
    
    
}
//APIClient.shared.uploadMedia(image: mainImage, videoURL: videoURL, progressHandler: <#T##(Float) -> Void#>)

//@MainActor
//class ListingAddViewModel: ObservableObject {
//
//    @Published var realEstateType: String? = nil
//    @Published var apartmnetName: String? = nil
//    @Published var apartmnetPrice: Int? = nil
//    @Published var apartmentTotalMetres: Int? = nil
//    @Published var apartmentAge: Int? = nil
//    @Published var streetWidth: Int? = nil
//    @Published var apartmentFacingSide: String? = nil
//    @Published var apartmentNumberOfStreets: Int? = nil
//    @Published var apartmentCity: String? = nil
//    @Published var apartmentNeightbourHood: String? = nil
//    @Published var apartmentLatitude: Double? = nil
//    @Published var apartmentLongitude: Double? = nil
//
//    // Media properties
//    @Published var mainImage: UIImage?
//    @Published var additionalImages: [UIImage] = []
//    @Published var videoURL: URL?
//
//    // Uploaded URLs
//    @Published var mainImageUrl: String?
//    @Published var additionalImagesUrls: [String] = []
//    @Published var additionalVideoUrl: String?
//
//    @Published var advertiserDescription: String? = nil
//    @Published var schemeNumber: String? = nil
//    @Published var aparmentPartNumber: String? = nil
//    @Published var valLicenceNumber: String? = nil
//    @Published var advertisingLicenceNumber: String? = nil
//    @Published var description: String? = nil
//    @Published var availability: Int? = nil
//    @Published var villaType: String? = nil
//    @Published var intendedUse: String? = nil
//    @Published var floorNumber: Int = 1
//    @Published var availableFloors: Int = 1
//    @Published var bedroomCount: Int = 1
//    @Published var bathroomCount: Int = 1
//    @Published var livingRoomCount: Int = 1
//    @Published var seatingAreaCount: Int = 1
//    @Published var availableParking: Bool? = nil
//    @Published var services: [String] = []
//    @Published var extraFeatures: [String] = []
//
//    @Published var listingResponse: ListingAddResponse?
//    @Published var isListingLoading: Bool = false
//
//    let userId: Int? = {
//        return UserDefaults.standard.integer(forKey: "userId")
//    }()
//
//    func sendListing() {
//        isListingLoading = true
//        uploadMedia { success in
//            if success {
//                Task {
//                    do {
//                        let response = try await APIClient.shared.callWithStatusCode(
//                            .sendListing(
//                                userId: 1,
//                                realEstateType: self.realEstateType ?? "",
//                                apartmnetName: self.apartmnetName ?? "",
//                                apartmnetPrice: self.apartmnetPrice ?? 0,
//                                apartmentTotalMetres: self.apartmentTotalMetres ?? 0,
//                                apartmentAge: self.apartmentAge ?? 0,
//                                streetWidth: self.streetWidth ?? 0,
//                                apartmentFacingSide: self.apartmentFacingSide ?? "",
//                                apartmentNumberOfStreets: self.apartmentNumberOfStreets ?? 0,
//                                apartmentCity: self.apartmentCity ?? "",
//                                apartmentNeightbourHood: self.apartmentNeightbourHood ?? "",
//                                apartmentLatitude: self.apartmentLatitude ?? 0,
//                                apartmentLongitude: self.apartmentLongitude ?? 0,
//                                apartmentMainImageUrl: self.mainImageUrl ?? "",
//                                apartmentAdditionaImages: self.additionalImagesUrls,
//                                additionalVideoUrl: self.additionalVideoUrl ?? "",
//                                advertiserDescription: self.advertiserDescription ?? "",
//                                schemeNumber: self.schemeNumber ?? "",
//                                aparmentPartNumber: self.aparmentPartNumber ?? "",
//                                valLicenceNumber: self.valLicenceNumber ?? "",
//                                advertisingLicenceNumber: self.advertisingLicenceNumber ?? "",
//                                description: self.description ?? "",
//                                availability: self.availability ?? 1,
//                                villaType: self.villaType ?? "",
//                                intendedUse: self.intendedUse ?? "",
//                                floorNumber: self.floorNumber,
//                                availableFloors: self.availableFloors,
//                                bedroomCount: self.bedroomCount,
//                                bathroomCount: self.bathroomCount,
//                                livingRoomCount: self.livingRoomCount,
//                                seatingAreaCount: self.seatingAreaCount,
//                                availableParking: self.availableParking ?? true,
//                                services: self.services,
//                                extraFeatures: self.extraFeatures
//                            ),
//                            decodeTo: ListingAddResponse.self
//                        )
//
//                        DispatchQueue.main.async {
//                            self.listingResponse = response.data
//                            self.isListingLoading = false
//                            print("Success in sending listing: \(response)")
//                        }
//                    } catch {
//                        self.isListingLoading = false
//                        print("Error in sending listing: \(error)")
//                    }
//                }
//            }
//        }
//    }
//
//    func uploadMedia(completion: @escaping (Bool) -> Void) {
//        let dispatchGroup = DispatchGroup()
//
//        var uploadedMainImageUrl: String?
//        var uploadedAdditionalImagesUrls: [String] = []
//        var uploadedVideoUrl: String?
//
//        // Upload main image
//        if let mainImage = mainImage {
//            dispatchGroup.enter()
//            uploadImage(mainImage) { url in
//                DispatchQueue.main.async {
//                    uploadedMainImageUrl = url
//                    dispatchGroup.leave()
//                }
//            }
//        }
//
//        for image in additionalImages {
//            dispatchGroup.enter()
//            uploadImage(image) { url in
//                DispatchQueue.main.async {
//                    if let url = url {
//                        uploadedAdditionalImagesUrls.append(url)
//                    }
//                    dispatchGroup.leave()
//                }
//            }
//        }
//
//        if let videoURL = videoURL {
//            dispatchGroup.enter()
//            APIClient.shared.uploadMedia(fileURL: videoURL) { result in
//                DispatchQueue.main.async {
//                    switch result {
//                    case .success(let url):
//                        uploadedVideoUrl = url
//                    case .failure(let error):
//                        print("Video upload failed: \(error)")
//                    }
//                    dispatchGroup.leave()
//                }
//            }
//        }
//
//        dispatchGroup.notify(queue: .main) {
//            self.mainImageUrl = uploadedMainImageUrl
//            self.additionalImagesUrls = uploadedAdditionalImagesUrls
//            self.additionalVideoUrl = uploadedVideoUrl
//            completion(true)
//        }
//    }
//
//    private func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
//        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
//            print("Failed to convert image to JPEG")
//            completion(nil)
//            return
//        }
//
//        let tempDir = FileManager.default.temporaryDirectory
//        let tempURL = tempDir.appendingPathComponent("\(UUID().uuidString).jpg")
//
//        do {
//            try imageData.write(to: tempURL)
//            print("Image saved to temporary URL: \(tempURL)")
//        } catch {
//            print("Failed to save image to temporary URL: \(error)")
//            completion(nil)
//            return
//        }
//
//        APIClient.shared.uploadMedia(fileURL: tempURL) { result in
//            switch result {
//            case .success(let url):
//                print("Image uploaded successfully: \(url)")
//                completion(url)
//            case .failure(let error):
//                print("Image upload failed: \(error)")
//                completion(nil)
//            }
//        }
//    }
//}


@available(iOS 16.0, *)
struct ListingAddView: View {
    
    @StateObject var viewModel = ListingAddViewModel()
    
    @State var filteredSections = 3
    let totalSections = 10
    
    @State var selectedStatus: String? = ""
    @State var priceString: String = ""
    @State var metreAreaString: String = ""
    
    @State var showNextView: Bool = false
    @State var selectedMainImage: PhotosPickerItem?
    @State var selectedAdditionalImages: [PhotosPickerItem] = []
    @State var selectedVideo: PhotosPickerItem?
    
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
                MediaUploader()
            }
            .frame(maxWidth: .infinity)
            .padding()
            NavigationLink(destination: ChooseLocationView(), isActive: $showNextView) {
                EmptyView()
            }
            .safeAreaInset(edge: .bottom) {
                MainButton("Submit Listing") {
                    viewModel.sendListings()
                }
                .padding(.horizontal, 24)
                .padding(.vertical)
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
    
    @ViewBuilder func MediaUploader() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Upload Media")
                .font(.headline)
                .padding(.bottom, 5)
            
            // MARK: - Main Image Picker
            VStack {
                Text("Main Image")
                    .font(.subheadline)
                
                PhotosPicker(selection: $selectedMainImage, matching: .images, photoLibrary: .shared()) {
                    if let image = viewModel.mainImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(alignment: .topTrailing) {
                                Button(action: { viewModel.mainImage = nil }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                        .background(Color.white.clipShape(Circle()))
                                }
                                .offset(x: -10, y: 10)
                            }
                    } else {
                        uploadButtonView(icon: "photo.fill", text: "Select Main Image")
                    }
                }
                .onChange(of: selectedMainImage) { newItem in
                    loadImage(from: newItem) { image in
                        viewModel.mainImage = image
                    }
                }
            }
            
            // MARK: - Additional Images Picker
            VStack {
                Text("Additional Images (\(viewModel.additionalImages.count)/5)")
                    .font(.subheadline)
                
                PhotosPicker(selection: $selectedAdditionalImages, maxSelectionCount: 5, matching: .images) {
                    uploadButtonView(icon: "photo.stack", text: "Select Additional Images")
                }
                .onChange(of: selectedAdditionalImages) { newItems in
                    for item in newItems {
                        loadImage(from: item) { image in
                            viewModel.additionalImages.append(image)
                        }
                    }
                }
                
                // Display selected additional images
                if !viewModel.additionalImages.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(Array(viewModel.additionalImages.enumerated()), id: \.0) { index, image in
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                                    Button(action: { viewModel.additionalImages.remove(at: index) }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.red)
                                            .background(Color.white.clipShape(Circle()))
                                    }
                                    .offset(x: -5, y: 5)
                                }
                            }
                        }
                    }
                }
            }
            
            // MARK: - Video Picker
            VStack {
                Text("Video")
                    .font(.subheadline)
                
                PhotosPicker(selection: $selectedVideo, matching: .videos) {
                    if let videoURL = viewModel.videoURL {
                        HStack {
                            Image(systemName: "video.fill")
                            Text("Video Selected")
                                .foregroundColor(.green)
                            Spacer()
                            Button(action: { viewModel.videoURL = nil }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    } else {
                        uploadButtonView(icon: "video.fill", text: "Select Video")
                    }
                }
                .onChange(of: selectedVideo) { newItem in
                    loadVideo(from: newItem) { url in
                        viewModel.videoURL = url
                    }
                }
            }
        }
        .padding()
    }
    @ViewBuilder
    private func uploadButtonView(icon: String, text: String) -> some View {
        HStack {
            Image(systemName: icon)
            Text(text)
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
    }
    //    @ViewBuilder
    //    func MediaUploader() -> some View {
    //        VStack(alignment: .leading) {
    //            Text("Upload Media")
    //                .font(.headline)
    //
    //            // Main Image Picker
    //            PhotosPicker(selection: $selectedMainImage, matching: .images, photoLibrary: .shared()) {
    //                HStack {
    //                    Image(systemName: "photo.fill")
    //                    Text(viewModel.mainImage != nil ? "Main Image Selected" : "Select Main Image")
    //                }
    //                .frame(height: 50)
    //                .frame(maxWidth: .infinity)
    //                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
    //            }
    //            .onChange(of: selectedMainImage) { newItem in
    //                loadImage(from: newItem) { image in
    //                    viewModel.mainImage = image
    //                }
    //            }
    //
    //
    //            // Additional Images Picker
    //            PhotosPicker(selection: $selectedAdditionalImages, maxSelectionCount: 5, matching: .images) {
    //                HStack {
    //                    Image(systemName: "photo.stack")
    //                    Text(viewModel.additionalImages.isEmpty ? "Select Additional Images" : "\(viewModel.additionalImages.count) Images Selected")
    //                }
    //                .frame(height: 50)
    //                .frame(maxWidth: .infinity)
    //                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
    //            }
    //            .onChange(of: selectedAdditionalImages) { newItems in
    //                for item in newItems {
    //                    loadImage(from: item) { image in
    //                        viewModel.additionalImages.append(image)
    //                    }
    //                }
    //            }
    //
    //
    //            PhotosPicker(selection: $selectedVideo, matching: .videos) {
    //                HStack {
    //                    Image(systemName: "video.fill")
    //                    Text(viewModel.videoURL != nil ? "Video Selected" : "Select Video")
    //                }
    //                .frame(height: 50)
    //                .frame(maxWidth: .infinity)
    //                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
    //            }
    //            .onChange(of: selectedVideo) { newItem in
    //                loadVideo(from: newItem) { url in
    //                    viewModel.videoURL = url
    //                }
    //            }
    //
    //        }
    //        .padding()
    //    }
    
    // MARK: Load Image Helper
    @available(iOS 16.0, *)
    private func loadImage(from pickerItem: PhotosPickerItem?, completion: @escaping (UIImage) -> Void) {
        guard let pickerItem else { return }
        Task {
            if let data = try? await pickerItem.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                completion(image)
            }
        }
    }
    
    // MARK: Load Video Helper
    @available(iOS 16.0, *)
    private func loadVideo(from pickerItem: PhotosPickerItem?, completion: @escaping (URL) -> Void) {
        guard let pickerItem else { return }
        Task {
            if let url = try? await pickerItem.loadTransferable(type: URL.self) {
                completion(url)
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
    if #available(iOS 16.0, *) {
        ListingAddView()
    } else {
        // Fallback on earlier versions
    }
}
