//
//  CachedImage.swift
//  ValidationComponents
//
//  Created by Shohruhmirzo Alijonov on 13/12/24.
//

import SwiftUI
import Kingfisher

struct CachedImage: View {
    
    let imageUrl: URL?
    
    init(imageUrl: String, expiration: StorageExpiration = .days(1)) {
        self.imageUrl = URL(string: imageUrl)
        Kingfisher.ImageCache.default.memoryStorage.config.countLimit = 100
        Kingfisher.ImageCache.default.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024
        Kingfisher.ImageCache.default.memoryStorage.config.expiration = .expired
        Kingfisher.ImageCache.default.diskStorage.config.expiration = expiration
    }
    
    var body: some View {
        KFImage(imageUrl)
            .placeholder {
                ZStack {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .shimmering(active: true)
                }
            }
            .fade(duration: 0.25)
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
}

final class ImagePrefetcher {
    static let instance = ImagePrefetcher()
    var prefetchers: [String: Kingfisher.ImagePrefetcher] = [:]
    
    init() {}
    
    func startPrefetching(id: String, urls: [String]) {
        prefetchers[id] = Kingfisher.ImagePrefetcher(urls: urls.compactMap { URL(string: $0) })
        prefetchers[id]?.start()
    }
    
    func stopPrefetching(id: String) {
        prefetchers[id]?.stop()
    }
}


#Preview("Image") {
    CachedImage(imageUrl: "https://t.me/Westminster_group_Tashkent/664025")
}
