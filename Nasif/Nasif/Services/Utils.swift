//
//  Utils.swift
//  Karly
//
//  Created by Shohjahon Rakhmatov on 02/11/24.
//

import SwiftUI

class Utils {
    
    static let shared = Utils()
    
    func requestNotificationAuthorization(completion: @escaping(Bool, Error?) -> ()) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { success, error in
            completion(success, error)
        }
    }
    
    static func hapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    static func notificationFeedback(_ feedback: UINotificationFeedbackGenerator.FeedbackType = .error) {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.prepare()
        notificationFeedback.notificationOccurred(feedback)
    }
    
    func dismissKeyBoard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func compressImage(image: UIImage?) -> UIImage? {
        let maxSize = 5000000
        guard var jpgData = image?.jpegData(compressionQuality: 1) else { return nil }
        let currentSize = jpgData.count
        if currentSize > maxSize {
            let image = CIImage(data: jpgData)
            let filter = CIFilter(name: "CILanczosScaleTransform")
            filter?.setValue(image, forKey: kCIInputImageKey)
            filter?.setValue(0.5, forKey: kCIInputScaleKey)
            if let result = filter?.outputImage {
                let converter = UIImage(ciImage: result)
                if let data = converter.jpegData(compressionQuality: 1) {
                    jpgData = data
                }
            }
        }
        let newSize = jpgData.count
        let newImage = UIImage(data: jpgData)
        if newSize > maxSize {
            return compressImage(image: newImage)
        }
        return newImage
    }
    
    func share(text: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else {
            return
        }
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        rootVC.present(activityVC, animated: true, completion: nil)
    }
    
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func openAppStore() {
        // example app store id if needed
        if let url = URL(string: "itms-apps://itunes.apple.com/uz/app/karly/id") {
            UIApplication.shared.open(url)
        }
    }
    
}
