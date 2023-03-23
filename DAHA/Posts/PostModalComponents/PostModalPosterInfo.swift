//
//  PostModalPosterInfo.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/31/23.
//

import SwiftUI
import Firebase

struct PostModalPosterInfo: View {
    @State var post: PostModel
    @Environment(\.colorScheme) var colorScheme

    
    var body: some View {
        HStack{
            Text("@\(post.username)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            Image(systemName:"circle.fill")
                .font(.system(size: 3.8, weight: .bold))
                .foregroundColor(.gray)
            
            Text(post.postedAt?.dateValue().timeAgoDisplay() ?? "")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.gray)
            Spacer()
            
            (Text(Image(systemName: type_images[post.type] ?? "")) + Text(" ") + Text(post.type.uppercased()))
                .lineLimit(1)
                .font(.system(size: 15, weight: .heavy))
                .layoutPriority(1)
                .padding(.trailing, 10)
                .foregroundColor(Color(hex: deepBlue))

            }
        .padding(.leading, 12)
        } //:HStack
       
    }

struct PostModalPosterInfo_Previews: PreviewProvider {
    static var previews: some View {
        let startTime = Date.now
        let startTimestamp: Timestamp = Timestamp(date: startTime)
        
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: startTimestamp, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "Request", keywordsForLookup: [], reporters: [])
        PostModalPosterInfo(post: post)
    }
}
