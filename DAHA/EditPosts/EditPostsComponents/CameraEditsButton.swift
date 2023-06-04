//
//  CameraEditsButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 6/4/23.
//

import SwiftUI

struct CameraEditsButton: View {
    
    @Binding var post: PostModel
    @Binding var images: [UIImage]
    @State private var image: UIImage? = nil
    @State private var isPresented: Bool = false
    
    
    var body: some View {
        Button(action: {
            if (images.count + post.imageURLs.count) < 3{
                isPresented = true
            }
        }) {
            Text(Image(systemName: "camera"))
                .font(.system(size: 45, weight: .regular))
                .padding(18)
                .background(Circle().stroke((images.count + post.imageURLs.count) == 3 ? .gray : Color(hex: deepBlue), lineWidth: 3))
                .foregroundColor((images.count + post.imageURLs.count) == 3 ? .gray : Color(hex: deepBlue))
                
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $isPresented){
            ImagePicker(image: $image, images: $images)
                .ignoresSafeArea()
        }
    }
}

//struct CameraEditsButton_Previews: PreviewProvider {
//    static var previews: some View {
//        CameraEditsButton()
//    }
//}
