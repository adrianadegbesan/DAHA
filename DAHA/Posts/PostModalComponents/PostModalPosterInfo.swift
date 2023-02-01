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
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            Image(systemName:"circle.fill")
                .scaleEffect(0.5)
                .foregroundColor(.gray)
            Text(post.postedAt?.dateValue().timeAgoDisplay() ?? "")
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            Spacer()
        } //:HStack
    }
}

struct PostModalPosterInfo_Previews: PreviewProvider {
    static var previews: some View {
        let startTime = Date.now
        let startTimestamp: Timestamp = Timestamp(date: startTime)
        
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: startTimestamp, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [])
        PostModalPosterInfo(post: post)
    }
}
