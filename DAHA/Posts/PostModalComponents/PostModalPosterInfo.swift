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

    
    var body: some View {
        HStack{
            Text("@\(post.username)")
                .minimumScaleFactor(0.5)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.gray)
            Image(systemName:"circle.fill")
                .minimumScaleFactor(0.5)
                .font(.system(size: 5, weight: .bold))
                .foregroundColor(.gray)
            Text(post.postedAt?.dateValue().timeAgoDisplay() ?? "")
                .minimumScaleFactor(0.5)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.gray)
            Spacer()
            
            (Text(Image(systemName: type_images[post.type] ?? "")) + Text(" ") + Text(post.type.uppercased()))
                .lineLimit(1)
                .minimumScaleFactor(0.3)
                .font(.system(size: 13, weight: .bold))
                .layoutPriority(1)
                .padding(.trailing, 10)

            }
        .padding(.leading, 12)
        } //:HStack
       
    }

struct PostModalPosterInfo_Previews: PreviewProvider {
    static var previews: some View {
        let startTime = Date.now
        let startTimestamp: Timestamp = Timestamp(date: startTime)
        
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: startTimestamp, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "Request", keywordsForLookup: [])
        PostModalPosterInfo(post: post)
    }
}
