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
                            let sideLength = min(
                                capturedImage!.size.width,
                                capturedImage!.size.height
                            ) + 35
                            let sourceSize = capturedImage!.size
                            let xOffset = (sourceSize.width - sideLength) / 2.0
                            let yOffset = (sourceSize.height - sideLength) / 2.0
                            
                            let cropRect = CGRect(
                                x: xOffset,
                                y: yOffset,
                                width: sideLength,
                                height: sideLength
                            ).integral
                            
                            let sourceCGImage = capturedImage!.cgImage!
                            let croppedCGImage = sourceCGImage.cropping(
                                to: cropRect
                            )!
                            
                            let croppedImage = UIImage(
                                cgImage: croppedCGImage,
                                scale: capturedImage!.imageRendererFormat.scale,
                                orientation: capturedImage!.imageOrientation
                            )
                            
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
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "multiply")
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(.gray)
            }
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
                .padding(.bottom)
            }
            .alert("Error Capturing Photo", isPresented: $error_alert, actions: {}, message: {Text("Cannot capture photo, please try again later")})
            
        }
    }
}
