//
//  PostImageView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/29/23.
//

import SwiftUI
import SDWebImageSwiftUI



struct PostImageView: View {
    @Binding var post: PostModel
    @State var owner : Bool
    @State var preview: Bool
    @State var reported: Bool
    @State private var opacity: Double = 0.1
    @Environment(\.colorScheme) var colorScheme
    @State private var showImagePopup : Bool = false
    
    
    var body: some View {
        
        VStack {
            if !post.imageURLs.isEmpty{
                TabView {
                    
                    if !preview{
                        ForEach(post.imageURLs, id: \.self) { item in
                            PostImage(post: $post, url: item)
                        }
                        
                        
        
                    } //: LOOP (NOT PREVIEW)
                    
                    else {
                        PostImage(post: $post, url: post.imageURLs[0])
                    }
                    
                } //: TAB
                .tabViewStyle(PageTabViewStyle())
                .cornerRadius(15)
                //            .padding(2.7)
                .frame(width: screenWidth * 0.385, height: 175)
                .overlay (
                    RoundedRectangle(cornerRadius: 15)
                        .strokeBorder(lineWidth: colorScheme == .dark ? 2 : 2)
                        .foregroundColor(post.price == "Sold" || post.price == "Satisfied" ? Color(hex: color_new) : colorScheme == .light ? .gray : .gray)
                )
                .clipped()
            } else {
                ZStack{
                    Image(systemName: category_images[post.category] ?? "bag.fill")
                        .scaleEffect(3)
                        .frame(width: screenWidth * 0.385, height: 175)
                        .foregroundColor( (post.category == "General" && colorScheme == .dark) ? .white : Color(hex: category_colors[post.category] ?? "000000") )
                        .overlay (
                            RoundedRectangle(cornerRadius: 15)
                                .strokeBorder(lineWidth: colorScheme == .dark ? 2 : 2)
                                .foregroundColor(post.price == "Sold" || post.price == "Satisfied" ? Color(hex: color_new) : colorScheme == .light ? .gray : .gray)
                        )
                }
               
            }

        }
    }
    
    struct PostImageView_Previews: PreviewProvider {
        static var previews: some View {
            let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "", keywordsForLookup: [], reporters: [])
            PostImageView(post: .constant(post), owner: false, preview: false, reported: false)
        }
    }
}


func getValidAspectRatio(image : UIImage?) -> Bool {
    
    if image == nil {
        return false
    } else {
        let width = image!.size.width
        let height = image!.size.height
        
        print("\(width)")
        print("\(height)")
        
        let ratio = width/height
        
        if ratio < 0.5 || ratio > 1.5{
            return false
        } else {
            return true
        }
    }
    
    
}


