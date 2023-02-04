//
//  CameraButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/2/23.
//

import SwiftUI

struct CameraButton: View{
    @Binding var images: [UIImage]
    @State var image: UIImage? = nil
    @State private var isPresented: Bool = false
    
    var body: some View {
        Button(action: {
            if images.count < 3{
                HeavyFeedback()
                isPresented = true
            }
        }) {
            Image(systemName: "camera")
                .resizable()
                .foregroundColor(images.count == 3 ? .gray : .blue)
                .frame(width: screenWidth * 0.23, height: screenHeight * 0.08)
        }
        .sheet(isPresented: $isPresented){
//                ImagePickerView(selectedImage: self.$image, sourceType: .camera)
            ImagePicker(image: $image)
                .onChange(of: image){ value in
                    if image != nil{
                        images.append(image!)
                    }
            }
        }
    }
}

struct CameraButton_Previews: PreviewProvider {
    static var previews: some View {
        let images: [UIImage] = []
        CameraButton(images: .constant(images))
    }
}
