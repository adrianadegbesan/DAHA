//
//  CameraRollEditsButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 6/4/23.
//

import SwiftUI

struct CameraRollEditsButton: View {
    
    @Binding var post: PostModel
    @Binding var images: [UIImage]
    @State private var images_temp: [UIImage] = []
    @State private var isPresented: Bool = false
    
    var body: some View {
        Button(action: {
            if (images.count + post.imageURLs.count) < 3{
                isPresented = true
            }
        }){
            Text(Image(systemName: "photo.on.rectangle"))
                .font(.system(size: 45, weight: .regular))
                .padding(18)
                .background(Circle().stroke((images.count + post.imageURLs.count) == 3 ? .gray : Color(hex: deepBlue), lineWidth: 3))
                .foregroundColor((images.count + post.imageURLs.count) == 3 ? .gray : Color(hex: deepBlue))
                
            
        }
        .buttonStyle(.plain)
        .onChange(of: images_temp){ value in
            for image in images_temp {
                if !images.contains(image) && (images.count + post.imageURLs.count) < 3{
                    images.append(image)
                }
            }
        }
        .sheet(isPresented: $isPresented){
            PhotoPicker(images: $images_temp, selectionLimit: 3 - (images.count + post.imageURLs.count) , filter: .images)
 
        }
    }
}

//struct CameraRollEditsButton_Previews: PreviewProvider {
//    static var previews: some View {
//        CameraRollEditsButton()
//    }
//}
