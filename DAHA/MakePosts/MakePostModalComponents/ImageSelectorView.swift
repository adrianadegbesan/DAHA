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
    @Environment(\.colorScheme) var colorScheme
    
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
                    ForEach(images, id: \.self) { image in
                        ImagePreview(image: image, images:$images)
                        
                    } //: LOOP
                } //: TAB
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .padding(2.3)
                .frame(width: screenWidth * 0.94, height: screenHeight * 0.45)
            } else {
                ZStack{
                    Color.clear
                        .padding(2.3)
                    
                    Image("Logo")
                        .overlay(Rectangle().stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
                        .opacity(0.7)
                        .padding(.bottom, screenHeight * 0.05)
                        
                }
                .frame(width: screenWidth * 0.94, height: screenHeight * 0.45)
             
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
