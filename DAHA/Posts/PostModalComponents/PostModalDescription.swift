//
//  PostModalDescription.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/31/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostModalDescription: View {
    @State var post: PostModel
    @State var opacity = 0.1
    @State var descriptionScroll : Bool = false
    @Binding var saved: Bool
    @State var owner: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(post.title)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .font(.system(size: 19, weight: .bold))
                    
                   
                
                Spacer()
                
                (Text(post.price == "Free" ? "" : "$") + Text(post.price))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .font(.system(size: 16, weight: .bold))
                 
            } //:HStack
            .padding(.leading, 10)
            .padding(.trailing, 10)

            if !post.imageURLs.isEmpty {
                TabView {
                    
                    ForEach(post.imageURLs, id: \.self) { item in
                        GeometryReader { proxy in
                            WebImage(url: URL(string: item))
                                .resizable()
                                .placeholder{
                                    ProgressView()
                                }
                                .indicator(.activity)
                                .scaledToFit()
                                .clipped()
                                .opacity(opacity)
                                .transition(.scale)
                                .overlay (
                                    Rectangle()
                                        .strokeBorder(lineWidth: 3)
                                )
                                .onAppear{
                                    withAnimation(.easeIn(duration: 0.3)){
                                        opacity = 1
                                    }
                                }
                                .modifier(ImageModifier(contentSize: CGSize(width: proxy.size.width, height: proxy.size.height)))
                        } //: GeometryReader
                      } //: LOOP
                    
                    
                } //: TAB
                .tabViewStyle(PageTabViewStyle())
    //            .cornerRadius(15)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .padding(2.3)
                .frame(width: screenWidth, height: screenHeight * 0.4)
    //            .frame(width: screenWidth * 0.92, height: screenHeight * 0.35)
                .clipped()

            } else {
                Image(systemName: category_images[post.category] ?? "bag.fill")
                    .scaleEffect(4)
                    .frame(width: screenWidth, height: screenHeight * 0.35)
                    .foregroundColor( (post.category == "General" && colorScheme == .dark) ? .white : Color(hex: category_colors[post.category] ?? "000000") )
                    .overlay (
        //                RoundedRectangle(cornerRadius: 15)
                        Rectangle()
                            .strokeBorder(lineWidth: 3)
                    )
            }
            
            HStack {
                HStack{
                    Text(post.description)
                        .padding(.leading, 10)
                    Spacer()
                }
                .padding(.bottom, 10)
                .frame(width: screenWidth * 0.9)
                
                HStack{
                    if !owner {
                        Spacer()
                        BookmarkButton(post: post, saved: $saved)
                            .padding(.trailing, 10)
                    }
                }
                .padding(.bottom, 10)
            }
        }
    }
}

struct PostModalDescription_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "100", imageURLs: [], channel: "Stanford", savers: [], type: "", keywordsForLookup: [])
        PostModalDescription(post: post, saved: .constant(false), owner: false)
    }
}
