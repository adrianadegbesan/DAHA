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
        
        
        if !post.imageURLs.isEmpty{
            TabView {
                
                if !preview{
                    ForEach(post.imageURLs, id: \.self) { item in
                        ZStack(alignment: .topTrailing){
                            WebImage(url: URL(string: item))
                                .resizable()
                                .placeholder{
                                    //                                        ProgressView()
                                    ZStack(alignment: .topTrailing){
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
                                .indicator(.activity)
                                .cornerRadius(15, corners: .allCorners)
//                                .scaledToFill()
//                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .clipped()
//                                .opacity(opacity)
//                                .onAppear{
//                                    withAnimation(.easeIn(duration: 0.3)){
//                                        opacity = 1
//                                    }
//                                }
                        }
                    
                    }
                    
                    
                    
                    
                } //: LOOP (NOT PREVIEW)
                
                else {
                    ZStack(alignment: .topTrailing){
                        WebImage(url: URL(string: post.imageURLs[0]))
                            .resizable()
                            .placeholder{
                                ZStack(alignment: .topTrailing){
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
                            .indicator(.activity)
                            .cornerRadius(15, corners: .allCorners)
                            .clipped()
//                            .opacity(opacity)
//                            .onAppear{
//                                withAnimation(.easeIn(duration: 0.3)){
//                                    opacity = 1
//                                }
//                            }
                        
                    } //(PREVIEW WITH JUST FIRST IMAGE)
                    
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
    
    struct PostImageView_Previews: PreviewProvider {
        static var previews: some View {
            let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "", keywordsForLookup: [], reporters: [])
            PostImageView(post: .constant(post), owner: false, preview: false, reported: false)
        }
    }
}