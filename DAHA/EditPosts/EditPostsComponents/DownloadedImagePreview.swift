//
//  DownloadedImagePreview.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 6/4/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct DownloadedImagePreview: View {
    
    @Binding var post: PostModel
    @State var url : String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack(alignment: .topLeading){
            WebImage(url: URL(string: url))
                .resizable()
                .placeholder{
                    ZStack(alignment: .topTrailing){
                        Image(systemName: category_images[post.category] ?? "bag.fill")
                            .scaleEffect(3)
                            .foregroundColor( (post.category == "General" && colorScheme == .dark) ? .white : Color(hex: category_colors[post.category] ?? "000000") )
                            .overlay (
                                RoundedRectangle(cornerRadius: 15)
                                    .strokeBorder(lineWidth: colorScheme == .dark ? 2 : 2)
                            )
                    }
                }
                .indicator(.activity)
                .cornerRadius(15)
                .scaledToFit()
                .overlay (
                    RoundedRectangle(cornerRadius: 15)
                        .strokeBorder(lineWidth: 2)
                )
                .clipped()
            
            Image(systemName: "multiply.circle.fill")
                .foregroundColor(.red)
                .font(.system(size: 20))
                .background(Circle().fill(.white))
                .onTapGesture {
                    withAnimation{
                        let index = post.imageURLs.firstIndex(of: url)
                        print(url)
                        if index != nil{
                                post.imageURLs.remove(at: index!)
                        }
                    }
                }
                .offset(x: -3.5, y: -4.8)
        }

    }
}

//struct DownloadedImagePreview_Previews: PreviewProvider {
//    static var previews: some View {
//        DownloadedImagePreview()
//    }
//}
