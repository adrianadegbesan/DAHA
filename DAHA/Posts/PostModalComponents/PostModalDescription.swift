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
    @State private var opacity = 0.1
    @State private var descriptionScroll : Bool = false
    @State private var tabIndex = 0
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
            .padding(.leading, 12)
            .padding(.trailing, 12)

            if !post.imageURLs.isEmpty {
                TabView(selection: $tabIndex){
                    
                    ForEach(post.imageURLs.indices, id: \.self) { i in
                        GeometryReader { proxy in
                            WebImage(url: URL(string: post.imageURLs[i]))
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
                                .tag(i)
                        } //: GeometryReader
                      } //: LOOP
                    
                    
                } //: TAB
                .tabViewStyle(.page(indexDisplayMode: .never))
    //            .cornerRadius(15)
                .padding(2.3)
                .frame(width: screenWidth, height: screenHeight * 0.4)
    //            .frame(width: screenWidth * 0.92, height: screenHeight * 0.35)
                .clipped()
                
                if post.imageURLs.count > 1{
                    HStack{
                        Spacer()
                        HStack{
                            ForEach(post.imageURLs.indices, id: \.self){ i in
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
                Image(systemName: category_images[post.category] ?? "bag.fill")
                    .scaleEffect(4)
                    .frame(width: screenWidth * 0.96, height: screenHeight * 0.35)
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
                        .padding(.leading, 12)
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
