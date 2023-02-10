//
//  Images.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import Foundation
import SwiftUI
import UIKit
import PhotosUI




extension Image {
    // extension for tab bar item icons
    func tabItemIcon(selectedIndex: Int, num: Int) -> some View {
        self
        .font(.system(size: 24, weight: .bold))
        .foregroundColor(selectedIndex == num ? Color(.blue) : .init(white: 0.6) )
    }
    
    // extension for the header bar side images
    func headerImage() -> some View {
        self
            .padding(.trailing, 20)
            .scaleEffect(1.5)
    }
}

let category_images = [
    "Bikes": "bicycle",
    "Tech": "iphone",
    "Clothing": "tshirt.fill",
    "Cars": "car.fill",
    "Art": "pencil.and.outline",
    "Furniture": "sofa.fill",
    "Books": "text.book.closed.fill",
    "Games":  "gamecontroller.fill",
    "Tickets": "ticket.fill",
    "General": "bag.fill"
]

let type_images = [
    "Request" : "figure.stand.line.dotted.figure.stand",
    "Listing" : "cart.circle"
]


struct PhotoPicker: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = PHPickerViewController
    
    @Binding var images: [UIImage]
    var selectionLimit: Int
    var filter: PHPickerFilter?
    var itemProviders: [NSItemProvider] = []
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = self.selectionLimit
        configuration.filter = self.filter
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return PhotoPicker.Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
        
        var parent: PhotoPicker
        
        init(parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            //Dismiss picker
            picker.dismiss(animated: true)

            if !results.isEmpty {
                parent.itemProviders = []
                parent.images = []
            }
            
            parent.itemProviders = results.map(\.itemProvider)
            loadImage()
        }
        
        private func loadImage() {
            for itemProvider in parent.itemProviders {
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        if let image = image as? UIImage {
                            self.parent.images.append(image)
                        } else {
                            print("Could not load image", error?.localizedDescription ?? "")
                        }
                    }
                }
            }
        }
        
    }
}


