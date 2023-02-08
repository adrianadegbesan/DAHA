//
//  ImageSelectorView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/2/23.
//

import SwiftUI

struct ImageSelectorView: View {
 
    @Binding var images: [UIImage]
    @State var image: UIImage?
    
    var body: some View {
        VStack{
            HStack{
                CameraRollButton(images: $images)
                    .onChange(of: images) { value in
                        print (images.count)
                    }
                
                CameraButton(images: $images)
                    .onChange(of: images) { value in
                        print (images.count)
                    }
                
                Spacer()
                
            }
            .padding(.bottom, 10)
            
            if !images.isEmpty{
                TabView {
                    ForEach(images, id: \.self) { image in
                        ImagePreview(image: image, images:$images)
                      
                  } //: LOOP
                } //: TAB
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .padding(2.3)
                .frame(width: screenWidth * 0.94, height: screenHeight * 0.45)
//                .overlay (
//                   Rectangle()
//                        .strokeBorder(lineWidth: 4)
//                )
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