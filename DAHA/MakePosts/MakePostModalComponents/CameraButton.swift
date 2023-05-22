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
                isPresented = true
            }
        }) {
//            Image(systemName: "camera")
//                .resizable()
//                .foregroundColor(images.count == 3 ? .gray : .blue)
//                .frame(width: 89.7, height: 67.52)
            Text(Image(systemName: "camera"))
                .font(.system(size: 45, weight: .regular))
                .padding(18)
                .background(Circle().stroke(images.count == 3 ? .gray : Color(hex: deepBlue), lineWidth: 3))
                .foregroundColor(images.count == 3 ? .gray : Color(hex: deepBlue))
                
        }
        .sheet(isPresented: $isPresented){
            ImagePicker(image: $image, images: $images)
                .ignoresSafeArea()
        }
    }
}

struct CameraButton_Previews: PreviewProvider {
    static var previews: some View {
        let images: [UIImage] = []
        CameraButton(images: .constant(images))
    }
}
