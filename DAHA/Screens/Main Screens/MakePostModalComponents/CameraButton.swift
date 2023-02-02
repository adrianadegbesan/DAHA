//
//  CameraButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/2/23.
//

import SwiftUI

struct CameraButton: View{
    @Binding var images: [UIImage]
    @State private var isPresented: Bool = false
    
    var body: some View {
        Image(systemName: "camera")
            .resizable()
            .foregroundColor(images.count == 3 ? .gray : .blue)
            .frame(width: screenWidth * 0.2, height: screenHeight * 0.08)
            .onTapGesture {
                if images.count < 3{
                    isPresented = true
                }
            }
            .sheet(isPresented: $isPresented){
                ImagePickerView(selectedImage: self.$images, sourceType: .camera)
            }
    }
}

struct CameraButton_Previews: PreviewProvider {
    static var previews: some View {
        let images: [UIImage] = []
        CameraButton(images: .constant(images))
    }
}
