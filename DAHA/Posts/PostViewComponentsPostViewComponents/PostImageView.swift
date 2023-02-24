//
//  PostImageView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/29/23.
//

import SwiftUI
import SDWebImageSwiftUI



struct PostImageView: View {
   @State var post: PostModel
   @State var owner : Bool
   @State var preview: Bool
   @State var reported: Bool
   @State var opacity: Double = 0.1
   @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
       
            if !post.imageURLs.isEmpty{
                TabView {
                    
                    if !preview{
                        ForEach(post.imageURLs, id: \.self) { item in
                            ZStack(alignment: .topTrailing){
                                WebImage(url: URL(string: item))
                                    .resizable()
                                    .placeholder{
                                        ProgressView()
                                    }
                                    .indicator(.activity)
                                    .cornerRadius(15, corners: .allCorners)
                                    .clipped()
                                    .opacity(opacity)
                                    .onAppear{
                                        withAnimation(.easeIn(duration: 0.3)){
                                            opacity = 1
                                        }
                                    }
                                
//                                if !preview && !owner{
//                                    ReportButton(post: post, reported: $reported)
//                                        .padding(.trailing, 6)
//                                        .padding(.top, 8)
//                                }
                            }
                        }
                    
                  
                        
                    
                    } //: LOOP (NOT PREVIEW)
                    
                    else {
                        ZStack(alignment: .topTrailing){
                            WebImage(url: URL(string: post.imageURLs[0]))
                                .resizable()
                                .placeholder{
                                    ProgressView()
                                }
                                .indicator(.activity)
                                .cornerRadius(15, corners: .allCorners)
                                .clipped()
                                .opacity(opacity)
                                .onAppear{
                                    withAnimation(.easeIn(duration: 0.3)){
                                        opacity = 1
                                    }
                                }
                            
                        } //(PREVIEW WITH JUST FIRST IMAGE)
                        
                    }
                    
                } //: TAB
                .tabViewStyle(PageTabViewStyle())
                .cornerRadius(15)
                //            .padding(2.7)
                .frame(width: screenWidth * 0.385, height: screenHeight * 0.21)
                .overlay (
                    RoundedRectangle(cornerRadius: 15)
                        .strokeBorder(lineWidth: 1.5)
                    //                    .strokeBorder(Color(hex: category_colors[post.category] ?? "000000"), lineWidth: 1.5)
                )
                .clipped()
            } else {
                ZStack(alignment: .topTrailing){
                    Image(systemName: category_images[post.category] ?? "bag.fill")
                        .scaleEffect(3)
                        .frame(width: screenWidth * 0.385, height: screenHeight * 0.21)
                        .foregroundColor( (post.category == "General" && colorScheme == .dark) ? .white : Color(hex: category_colors[post.category] ?? "000000") )
                        .overlay (
                            RoundedRectangle(cornerRadius: 15)
                                .strokeBorder(lineWidth: colorScheme == .dark ? 1.5 : 2.7)
                        )
                    
                    
                    if !preview && !owner{
                        ReportButton(post: post, reported: $reported)
                            .padding(.trailing, 6)
                            .padding(.top, 8)
                    }
                }
                //                .overlay (
                //                    RoundedRectangle(cornerRadius: 15)
                //                        .strokeBorder((colorScheme != .dark && post.category != "General") ? Color(hex: category_colors[post.category] ?? "000000"): .white , lineWidth: 1)
                //                )
            }
        
      
    }
}

struct PostImageView_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "", keywordsForLookup: [])
        PostImageView(post: post, owner: false, preview: false, reported: false)
    }
}
