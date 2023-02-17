//
//  PosterInfoView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/29/23.
//

import SwiftUI
import Firebase

struct PosterInfoView: View {
    
    @State var post: PostModel
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack(spacing: 3){
            Text("@\(post.username)")
                .lineLimit(1)
                .minimumScaleFactor(0.001)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.gray)
            
            Image(systemName:"circle.fill")
                .minimumScaleFactor(0.5)
                .font(.system(size: 3.5, weight: .bold))
                .foregroundColor(.gray)
            
            Text(post.postedAt?.dateValue().timeAgoDisplay() ?? "")
                .lineLimit(1)
                .minimumScaleFactor(0.001)
                .font(.system(size: 9.5, weight: .semibold))
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(post.type == "Listing" ? Image(systemName: "cart.circle") : Image(systemName: "figure.stand.line.dotted.figure.stand"))
                .lineLimit(1)
                .minimumScaleFactor(0.001)
                .font(.system(size: post.type == "Request" ? 15.5 : 17, weight: .heavy))
            
//
//                .foregroundColor(post.category == "General" && colorScheme == .dark ? .white : Color(hex: category_colors[post.category] ?? deepBlue))
        }
        .padding(.bottom, 1)
    }
}

struct PosterInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let startTime = Date.now
        let startTimestamp: Timestamp = Timestamp(date: startTime)
        
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: startTimestamp, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "", keywordsForLookup: [])
        PosterInfoView(post: post)
    }
}
