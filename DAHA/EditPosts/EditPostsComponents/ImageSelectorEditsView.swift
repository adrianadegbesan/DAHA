//
//  ImageSelectorEditsView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 6/4/23.
//

import SwiftUI

struct ImageSelectorEditsView: View {
    
    @Binding var post: PostModel
    @Binding var images: [UIImage]
    @State var image: UIImage?
    @Environment(\.colorScheme) var colorScheme
   
    var body: some View {
        VStack{
            
            if !post.imageURLs.isEmpty {
                VStack(alignment: .leading){
                    HStack {
                        ForEach(post.imageURLs, id: \.self) { url in
                            DownloadedImagePreview(post: $post, url: url)
                                .padding(.horizontal, 10)
                        }
                    }
                    .frame(height: 180)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                }
                .transition(.opacity)

            }
                       
            
            HStack{
                CameraRollButton(images: $images)
                    .padding(.trailing, screenWidth * 0.025)
                
                CameraButton(images: $images)
                
                Spacer()
                
            }
            .padding(.bottom, 10)
            
           
            
            if !images.isEmpty{
                TabView(){
                    ForEach(images, id: \.self) { image in
                        ImagePreview(image: image, images: $images)
                        
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
                    
                        .frame(width: screenWidth * 0.94, height: screenHeight * 0.2)
                    
                }
            }
        }
    }
}

//struct ImageSelectorEditsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageSelectorEditsView()
//    }
//}
