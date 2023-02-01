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
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                
                PosterInfoView(post: post)
                
                CategoryViewPrev(post: post)
                
                PostDescriptionView(post: post)
                
                Text(post.price)
                    .font(.system(size: 20, weight: .bold))
                    .layoutPriority(1)
            }
            
            Spacer()
            
            PostImageView(post: post)
            
        } //HStack
        .frame(width: screenWidth * 0.89, height: screenHeight * 0.22)
        .padding()
        .overlay (
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color(hex: category_colors[post.category] ?? "000000"), lineWidth: 2)
                .shadow(radius: 3, y: 1)
        )
    }
}

struct PostViewPrev_Previews: PreviewProvider {
    static var previews: some View {
        let calendar = Calendar.current
        let startTime = calendar.date(byAdding: .day, value: -1, to: Date())
        let startTimestamp: Timestamp = Timestamp(date: startTime!)
        
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted, gave me alot of miles but kinda creaky sometimes", postedAt: startTimestamp, condition: "Good", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [])
        PostViewPrev(post: post)
    }
}
