//
//  SDWebImageHelpers.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/27/23.
//

import Foundation
import SwiftUI
import Photos
import SDWebImage
import SDWebImageSwiftUI


func saveImageToPhotoAlbum(url: URL, error_alert: Binding<Bool>) {
    let imageView = UIImageView()
    imageView.sd_setImage(with: url, completed: { (image, error, cacheType, url) in
        if let error = error {
            print("Error downloading image: \(error.localizedDescription)")
            error_alert.wrappedValue = true
            return
        }
        
        guard let image = image else {
            print("Error: Image is nil.")
            error_alert.wrappedValue = true
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        print("Image saved to photo album!")
    })
}


