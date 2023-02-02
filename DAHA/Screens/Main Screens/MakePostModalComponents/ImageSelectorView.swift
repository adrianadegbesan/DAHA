//
//  ImageSelectorView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/2/23.
//

import SwiftUI

struct ImageSelectorView: View {
 
    @Binding var images: [UIImage]
    
    var body: some View {
        VStack{
            HStack{
                CameraRollButton(images: $images)
                
                CameraButton(images: $images)
                
                Spacer()
                
            }
            .padding(.bottom, 10)
            
            if !images.isEmpty{
                TabView {
                    //post.imageURLs
                    ForEach(images, id: \.self) { image in
                    //AsyncImage
                        ImagePreview(image: image, images:$images)
                      
                  } //: LOOP
                } //: TAB
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .padding(2.3)
                .frame(width: screenWidth * 0.94, height: screenHeight * 0.45)
                .overlay (
                   Rectangle()
                        .strokeBorder(lineWidth: 5)
                )
            }
        }
    }
}

struct ImageSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        let images: [UIImage] = []
        ImageSelectorView(images: .constant(images))
    }
}
