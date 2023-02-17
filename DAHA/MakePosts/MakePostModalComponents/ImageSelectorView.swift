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
    @State private var tabIndex = 0
    
    var body: some View {
        VStack{
            HStack{
                CameraRollButton(images: $images)
                
                CameraButton(images: $images)
                
                Spacer()
                
            }
            .padding(.bottom, 10)
            
            if !images.isEmpty{
                TabView(selection: $tabIndex){
                    ForEach(images.indices, id: \.self) { i in
                        ImagePreview(image: images[i], images:$images, index: i)
                        
                    } //: LOOP
                } //: TAB
                .tabViewStyle(.page(indexDisplayMode: .never))
//                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .padding(2.3)
                .frame(width: screenWidth * 0.94, height: screenHeight * 0.45)
                
                if images.count > 1{
                    HStack{
                        Spacer()
                        HStack{
                            ForEach(images.indices, id: \.self){ i in
                                ImageIndicator(index: $tabIndex, my_index: i)
                                    .padding(.trailing, 3)
                            }
                        }
                        .padding(4)
                        .overlay(Capsule().stroke(lineWidth: 2))
                        Spacer()
                    }
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                }

            } else {
                ZStack{
                    Color.clear
                        .padding(2.3)
                    
                        .frame(width: screenWidth * 0.94, height: screenHeight * 0.2)
                    
                }
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
