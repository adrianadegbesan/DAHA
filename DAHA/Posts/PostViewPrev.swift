//
//  PostViewPrev.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/1/23.
//

import SwiftUI
import Firebase

struct PostViewPrev: View {
    @State var post: PostModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                
                PosterInfoView(post: post)
                Spacer().frame(height: 10)
                
                CategoryViewPrev(post: post)
                
                PostDescriptionView(post: post)
                
                HStack{
                    (Text(post.price == "Free" ? "" : "$") + Text(post.price))
                        .lineLimit(1)
                        .minimumScaleFactor(0.3)
                        .font(.system(size: 16, weight: .bold))
                        .layoutPriority(1)
                    
                    Spacer()
                    
                    if (post.type == "Request"){
                        Text("REQUEST")
                            .lineLimit(1)
                            .minimumScaleFactor(0.3)
                            .font(.system(size: 15, weight: .bold))
                            .layoutPriority(1)
                            .foregroundColor(Color(hex: category_colors[post.category] ?? "000000"))
                    } else {
                        Text("LISTING")
                            .lineLimit(1)
                            .minimumScaleFactor(0.3)
                            .font(.system(size: 15, weight: .bold))
                            .layoutPriority(1)
                            .foregroundColor(Color(hex: category_colors[post.category] ?? "000000"))
                    }
               
                }
            }
            
            Spacer()
            
            PostImageView(post: post)
        
            
        } //HStack
        .frame(width: screenWidth * 0.902, height: screenHeight * 0.2)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(colorScheme == .dark ? .gray : .black.opacity(0.7), lineWidth: colorScheme == .dark ? 2.5 : 2.5)

                .shadow(color: colorScheme == .dark ? .white : .black, radius: 1, y: 0)
        )
        .background(colorScheme == .dark ? .black.opacity(0.7) : .white)
        .cornerRadius(20)
        .padding(.horizontal, colorScheme == .light ? 3 : 0)
    }
}

struct PostViewPrev_Previews: PreviewProvider {
    static var previews: some View {
        let calendar = Calendar.current
        let startTime = calendar.date(byAdding: .day, value: -1, to: Date())
        let startTimestamp: Timestamp = Timestamp(date: startTime!)
        
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted, gave me alot of miles but kinda creaky sometimes", postedAt: startTimestamp, condition: "Good", category: "Bikes", price: "100", imageURLs: [], channel: "Stanford", savers: [], type: "Request", keywordsForLookup: [])
        PostViewPrev(post: post)
    }
}
