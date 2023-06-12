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
import TOCropViewController



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

// SF Symbol names for category images
let category_images = [
    "Bikes": "bicycle",
    "Tech": "iphone",
    "Clothing": "tshirt.fill",
    "Rides": "car.fill",
    "Services": "person.2.fill",
    "Furniture": "house.circle",
    "Books": "text.book.closed.fill",
    "Outdoor":  "sun.max.fill",
    "Tickets": "ticket.fill",
    "General": "bag.fill"
]

//SF Symbol names for type images
let type_images = [
    "Request" : "figure.stand.line.dotted.figure.stand",
    "Listing" : "cart.fill",
    "Borrow" : "figure.wave"
]


// Struct used for photo picker in making posts
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
            var imagesByIndex: [Int: UIImage] = [:]
            let group = DispatchGroup()
            
            for (index, itemProvider) in parent.itemProviders.enumerated() {
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    group.enter()
                    itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        defer { group.leave() }
                        
                        if let image = image as? UIImage {
                            imagesByIndex[index] = image
                        } else {
                            print("Could not load image", error?.localizedDescription ?? "")
                        }
                    }
                }
            }
            
            group.notify(queue: DispatchQueue.main) {
                // Add images to array in the order of their index
                self.parent.images = (0..<self.parent.itemProviders.count)
                    .compactMap { imagesByIndex[$0] }
            }
        }
    }
}
    //    class Coordinator: NSObject, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
    //
    //        var parent: PhotoPicker
    //
    //        init(parent: PhotoPicker) {
    //            self.parent = parent
    //        }
    //
    //        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    //            //Dismiss picker
    //            picker.dismiss(animated: true)
    //
    //            if !results.isEmpty {
    //                parent.itemProviders = []
    //                parent.images = []
    //            }
    //
    //            parent.itemProviders = results.map(\.itemProvider)
    //            loadImage()
    //        }
    //
    //        private func loadImage() {
    //            for itemProvider in parent.itemProviders {
    //                if itemProvider.canLoadObject(ofClass: UIImage.self) {
    //                    itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
    //                        if let image = image as? UIImage {
    //                            self.parent.images.append(image)
    //                        } else {
    //                            print("Could not load image", error?.localizedDescription ?? "")
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //
    //    }
    //}
    
    
    // Image Modifier for zoom functionality
    struct ImageModifier: ViewModifier {
        private var contentSize: CGSize
        private var min: CGFloat = 1.0
        private var max: CGFloat = 3.0
        @State var currentScale: CGFloat = 1.0
        
        init(contentSize: CGSize) {
            self.contentSize = contentSize
        }
        
        var doubleTapGesture: some Gesture {
            TapGesture(count: 2).onEnded {
                if currentScale <= min { currentScale = max } else
                if currentScale >= max { currentScale = min } else {
                    currentScale = ((max - min) * 0.5 + min) < currentScale ? max : min
                }
            }
        }
        
        func body(content: Content) -> some View {
            ScrollView([.horizontal, .vertical]) {
                content
                    .frame(width: contentSize.width * currentScale, height: contentSize.height * currentScale, alignment: .center)
                    .modifier(PinchToZoom(minScale: min, maxScale: max, scale: $currentScale))
            }
            .gesture(doubleTapGesture)
            .animation(.easeInOut, value: currentScale)
        }
    }
    
    class PinchZoomView: UIView {
        let minScale: CGFloat
        let maxScale: CGFloat
        var isPinching: Bool = false
        var scale: CGFloat = 1.0
        let scaleChange: (CGFloat) -> Void
        
        init(minScale: CGFloat,
             maxScale: CGFloat,
             currentScale: CGFloat,
             scaleChange: @escaping (CGFloat) -> Void) {
            self.minScale = minScale
            self.maxScale = maxScale
            self.scale = currentScale
            self.scaleChange = scaleChange
            super.init(frame: .zero)
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch(gesture:)))
            pinchGesture.cancelsTouchesInView = false
            addGestureRecognizer(pinchGesture)
        }
        
        required init?(coder: NSCoder) {
            fatalError()
        }
        
        @objc private func pinch(gesture: UIPinchGestureRecognizer) {
            switch gesture.state {
            case .began:
                isPinching = true
                
            case .changed, .ended:
                if gesture.scale <= minScale {
                    scale = minScale
                } else if gesture.scale >= maxScale {
                    scale = maxScale
                } else {
                    scale = gesture.scale
                }
                scaleChange(scale)
            case .cancelled, .failed:
                isPinching = false
                scale = 1.0
            default:
                break
            }
        }
    }
    
    struct PinchZoom: UIViewRepresentable {
        let minScale: CGFloat
        let maxScale: CGFloat
        @Binding var scale: CGFloat
        @Binding var isPinching: Bool
        
        func makeUIView(context: Context) -> PinchZoomView {
            let pinchZoomView = PinchZoomView(minScale: minScale, maxScale: maxScale, currentScale: scale, scaleChange: { scale = $0 })
            return pinchZoomView
        }
        
        func updateUIView(_ pageControl: PinchZoomView, context: Context) { }
    }
    
    struct PinchToZoom: ViewModifier {
        let minScale: CGFloat
        let maxScale: CGFloat
        @Binding var scale: CGFloat
        @State var anchor: UnitPoint = .center
        @State var isPinching: Bool = false
        
        func body(content: Content) -> some View {
            content
                .scaleEffect(scale, anchor: anchor)
                .animation(.spring(), value: isPinching)
                .overlay(PinchZoom(minScale: minScale, maxScale: maxScale, scale: $scale, isPinching: $isPinching))
        }
    }
    
//    Image Picker used for camera functionality
    struct ImagePicker: UIViewControllerRepresentable {
        @Binding var image: UIImage?
        @Binding var images: [UIImage]
        @Environment(\.presentationMode) var presentationMode

        func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.sourceType = .camera

            picker.delegate = context.coordinator
            return picker
        }

        func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

        }

        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
            let parent: ImagePicker

            init(_ parent: ImagePicker) {
                self.parent = parent
            }

            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                if let editedImage = info[.editedImage] as? UIImage {
                    parent.image = editedImage
                    parent.images.append(editedImage)
                } else if let originalImage = info[.originalImage] as? UIImage {
                    parent.image = originalImage
                    parent.images.append(originalImage)
                }

                parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }



//struct ImagePicker: UIViewControllerRepresentable {
//    @Binding var image: UIImage?
//    @Binding var images: [UIImage]
//    @Environment(\.presentationMode) private var presentationMode
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.sourceType = .camera
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate, TOCropViewControllerDelegate {
//        var parent: ImagePicker
//
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            guard let image = info[.originalImage] as? UIImage else { return }
//            let cropViewController = TOCropViewController(croppingStyle: .default, image: image)
//            cropViewController.delegate = self
//            picker.present(cropViewController, animated: true, completion: nil)
//        }
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            parent.presentationMode.wrappedValue.dismiss()
//        }
//
//        func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
//            cropViewController.dismiss(animated: true) {
//                    self.parent.image = image
//                    self.parent.images.append(image)
//                    self.parent.presentationMode.wrappedValue.dismiss()
//            }
//        }
//    }
//}

