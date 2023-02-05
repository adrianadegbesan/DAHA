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
            ZStack(alignment: .topLeading){
                Image(uiImage: image!)
                    .resizable()
                    .cornerRadius(15)
                    .clipped()
                    .scaledToFit()
                    .overlay (
                       RoundedRectangle(cornerRadius: 15)
                        .strokeBorder(lineWidth: 3)
                    )
                    .scaleEffect(0.93)
            
                Image(systemName: "multiply.circle.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 20))
                    .onTapGesture {
                        let index = images.firstIndex(of: image!)
                        if index != nil{
                            images.remove(at: index!)
                        }
                    }
                    .offset(x: 0.5, y: 1.35)
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
