//
//  PickPhotoButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/2/23.
//

import SwiftUI
import PhotosUI

struct CameraRollButton: View {
    
    @Binding var images: [UIImage]
    @State var images_temp: [UIImage] = []
    @State private var isPresented: Bool = false
    
    var body: some View {

        Button(action: {
            if images.count < 3{
                isPresented = true
            }
        }){
            Image(systemName: "photo")
                .resizable()
                .foregroundColor(images.count == 3 ? .gray : .blue)
                .frame(width: screenWidth * 0.23, height: screenHeight * 0.08)
                .padding(.trailing, screenHeight * 0.03)
        }.onChange(of: images_temp){ value in
            for image in images_temp {
                if !images.contains(image){
                    images.append(image)
                }
            }
        }
        .sheet(isPresented: $isPresented){
            PhotoPicker(images: $images_temp, selectionLimit: 3 - images.count , filter: .images)
 
        }
    }
}

struct CameraRollButton_Previews: PreviewProvider {
    static var previews: some View {
        let images: [UIImage] = []
        CameraRollButton(images: .constant(images))
    }
}
