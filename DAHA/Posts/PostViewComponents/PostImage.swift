//
//  PostImage.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 6/14/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostImage: View {
    @Binding var post: PostModel
    @State var url : String
    @Environment(\.colorScheme) var colorScheme
    @State private var cornerRadius: CGFloat = 0
    @State private var contentMode: ContentMode? = nil
    
    var body: some View {
        VStack{
            
            Group {
               if contentMode != nil {
                   WebImage(url: URL(string: url))
                       .resizable()
                       .onSuccess { image, _, _ in
                           self.cornerRadius = getValidAspectRatio(image: image) ? 15 : 0
                           self.contentMode = getValidAspectRatio(image: image) ? nil : .fit
                       }
                       .placeholder{
                           Image(systemName: category_images[post.category] ?? "bag.fill")
                               .scaleEffect(3)
                               .frame(width: screenWidth * 0.385, height: 175)
                               .foregroundColor((post.category == "General" && colorScheme == .dark) ? .white : Color(hex: category_colors[post.category] ?? "000000"))
                               .overlay (
                                   RoundedRectangle(cornerRadius: 15)
                                       .strokeBorder(lineWidth: colorScheme == .dark ? 2 : 2)
                                       .foregroundColor(post.price == "Sold" || post.price == "Satisfied" ? Color(hex: color_new) : colorScheme == .light ? .gray : .gray)
                               )
                       }
                       .indicator(.activity)
                       .transition(.opacity)
                       .cornerRadius(cornerRadius)
                       .aspectRatio(contentMode: contentMode!)
                       .clipped()
               } else {
                   WebImage(url: URL(string: url))
                       .resizable()
                       .onSuccess { image, _, _ in
                           self.cornerRadius = getValidAspectRatio(image: image) ? 15 : 0
                           self.contentMode = getValidAspectRatio(image: image) ? nil : .fit
                       }
                       .placeholder{
                           Image(systemName: category_images[post.category] ?? "bag.fill")
                               .scaleEffect(3)
                               .frame(width: screenWidth * 0.385, height: 175)
                               .foregroundColor((post.category == "General" && colorScheme == .dark) ? .white : Color(hex: category_colors[post.category] ?? "000000"))
                               .overlay (
                                   RoundedRectangle(cornerRadius: 15)
                                       .strokeBorder(lineWidth: colorScheme == .dark ? 2 : 2)
                                       .foregroundColor(post.price == "Sold" || post.price == "Satisfied" ? Color(hex: color_new) : colorScheme == .light ? .gray : .gray)
                               )
                       }
                       .indicator(.activity)
                       .transition(.opacity)
                       .cornerRadius(cornerRadius)
                       .clipped()
               }
           }
        }
    }
}

//struct PostImage_Previews: PreviewProvider {
//    static var previews: some View {
//        PostImage()
//    }
//}
