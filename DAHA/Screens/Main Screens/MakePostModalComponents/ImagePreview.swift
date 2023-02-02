//
//  ImagePreview.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/2/23.
//

import SwiftUI

struct ImagePreview: View {
    
    @State var image: UIImage?
    @Binding var images: [UIImage]
    
    var body: some View {
        if image != nil{
            ZStack {
                Image(uiImage: image!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth * 0.925, height: screenHeight * 0.9)
                    .padding(.bottom, 15)
                Image(systemName: "multiply.circle")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .onTapGesture {
                        let index = images.firstIndex(of: image!)
                        if index != nil{
                            images.remove(at: index!)
                        }
                    }
                    .offset(x: -screenWidth * 0.42, y: -screenHeight * 0.17)
            }
        }
    }
}

struct ImagePreview_Previews: PreviewProvider {
    static var previews: some View {
        let images: [UIImage] = []
        ImagePreview(image: nil, images: .constant(images))
    }
}
