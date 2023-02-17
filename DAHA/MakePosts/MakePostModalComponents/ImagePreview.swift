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
//    @State var index: Int
    
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
                    .background(Circle().fill(.white))
                    .onTapGesture {
                        let index = images.firstIndex(of: image!)
                        print(image!)
                        if index != nil{
                        print(index!)
//                        if index != 0{
//                            index -= index % 3
//                        }
//                            print(images)
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
