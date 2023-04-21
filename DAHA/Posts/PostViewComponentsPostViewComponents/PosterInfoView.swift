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
    @State private var timestampString = ""
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        HStack(spacing: 3){
            Text("@\(post.username)")
                .lineLimit(1)
                .minimumScaleFactor(0.4)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            Image(systemName:"circle.fill")
                .minimumScaleFactor(0.5)
                .font(.system(size: 2.5, weight: .bold))
                .foregroundColor(.secondary)
            
            Text(timestampString)
                .lineLimit(1)
                .minimumScaleFactor(0.4)
                .font(.system(size: 9.5, weight: .semibold))
                .foregroundColor(.secondary)
                .onAppear{
                    timestampString = post.postedAt?.dateValue().timeAgoDisplay() ?? ""
                }
            
            Spacer()
            
            Text(post.type == "Listing" ? Image(systemName: "cart.fill") : Image(systemName: "figure.stand.line.dotted.figure.stand"))
                .lineLimit(1)
                .minimumScaleFactor(0.4)
                .font(.system(size: 15.5, weight: .heavy))
                .foregroundColor(Color(hex: deepBlue))
            
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
        
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: startTimestamp, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "", keywordsForLookup: [], reporters: [])
        PosterInfoView(post: post)
    }
}
