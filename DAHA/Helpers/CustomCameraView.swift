//
//  CustomCameraView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/4/23.
//

import Foundation
import SwiftUI

struct CustomCameraView: View {
    
    let cameraService = CameraService()
    @State var flashMode = false
    @Binding var capturedImage: UIImage?
    @Binding var images: [UIImage]
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var error_alert: Bool = false
    
    var body: some View {
        ZStack{
            
    
            CameraView(cameraService: cameraService) { result in
                switch result {
                    
                case .success(let photo):
                    if let data = photo.fileDataRepresentation(){
                        capturedImage = UIImage(data: data)
                        
                        if capturedImage != nil{
                           let croppedImage = centerSquareCrop(image: capturedImage!)
                            images.append(croppedImage)
                        }
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        print("Error: no image data found")
                    }
                case .failure(let err):
                    error_alert = true
                    print(err.localizedDescription)
                }
            }
            
            Button(action: {
                flashMode.toggle()
                cameraService.toggleFlashMode()
            }){
                if flashMode{
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "bolt")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(.plain)
            .padding(.leading, screenWidth * 0.87)
            .padding(.bottom, screenHeight * 0.78)
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "multiply")
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(.white)
            }
            .buttonStyle(.plain)
            .padding(.trailing, screenWidth * 0.87)
            .padding(.bottom, screenHeight * 0.78)
            
            VStack{
                Spacer()
                Button(action:{
                    LightFeedback()
                    cameraService.capturePhoto()
                }){
                    Image(systemName: "circle")
                        .font(.system(size: 72))
                        .foregroundColor(.white)
                }
                .buttonStyle(.plain)
                .padding(.bottom, 45)
            }
            .alert("Error Capturing Photo", isPresented: $error_alert, actions: {}, message: {Text("Cannot capture photo, please try again later")})
            
        }
        .frame(width: screenWidth, height: screenHeight)
        .background(.black)
    }
}

func centerSquareCrop(image: UIImage) -> UIImage {
    let cgImage = image.cgImage!
    let contextImage = UIImage(cgImage: cgImage)
    let contextSize = contextImage.size
    var posX: CGFloat = 0.0
    var posY: CGFloat = 0.0
    var cgwidth: CGFloat = CGFloat(cgImage.width)
    var cgheight: CGFloat = CGFloat(cgImage.height)
    
    // See what size is longer and create the center off of that
    if contextSize.width > contextSize.height {
        posX = ((contextSize.width - contextSize.height) / 2)
        posY = 0
        cgwidth = contextSize.height
        cgheight = contextSize.height
    } else {
        posX = 0
        posY = ((contextSize.height - contextSize.width) / 2)
        cgwidth = contextSize.width
        cgheight = contextSize.width
    }
    
    let rect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
    
    // Create bitmap image from context using the rect
    let imageRef = cgImage.cropping(to: rect)!
    
    // Create a new image based on the imageRef and rotate back to the original orientation
    let croppedImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
    
    return croppedImage
    
}
