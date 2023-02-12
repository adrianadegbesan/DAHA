//
//  PostModalDescription.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/31/23.
//

import SwiftUI

struct PostModalDescription: View {
    @State var post: PostModel
    @State var opacity = 0.1
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
                    //post.imageURLs
                    ForEach(post.imageURLs, id: \.self) { item in
                        ZStack {
                            AsyncImage(url: URL(string: item)){ phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .clipped()
                                        .transition(.scale)
                                        .overlay (
                            //                RoundedRectangle(cornerRadius: 15)
                                            Rectangle()
                                                .strokeBorder(lineWidth: 3)
                                        )
                                        .opacity(opacity)
                                        .onAppear{
                                            withAnimation(.easeIn(duration: 0.3)){
                                                opacity = 1
                                            }
                                        }
                                case .failure(_):
                                    Image("Logo").overlay(Rectangle().stroke(colorScheme == .dark ? .white : .clear)).opacity(0.8)
                                case .empty:
                                    ProgressView()
                                @unknown default:
                                    ProgressView()
                                }
                            }
                        }
                  } //: LOOP
                } //: TAB
                .tabViewStyle(PageTabViewStyle())
    //            .cornerRadius(15)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .padding(2.3)
                .frame(width: screenWidth, height: screenHeight * 0.35)
    //            .frame(width: screenWidth * 0.92, height: screenHeight * 0.35)
                .clipped()

            } else {
                Image(systemName: category_images[post.category] ?? "bag.fill")
                    .scaleEffect(7)
                    .frame(width: screenWidth, height: screenHeight * 0.35)
                    .foregroundColor( (post.category == "General" && colorScheme == .dark) ? .white : Color(hex: category_colors[post.category] ?? "000000") )
                    .overlay (
        //                RoundedRectangle(cornerRadius: 15)
                        Rectangle()
                            .strokeBorder(lineWidth: 3)
                    )
            }
            
            HStack{
                Text(post.description)
                    .padding(.leading, 10)
            }
            .padding(.bottom, 10)
        }
    }
}

struct PostModalDescription_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "100", imageURLs: [], channel: "Stanford", savers: [], type: "", keywordsForLookup: [])
        PostModalDescription(post: post)
    }
}
