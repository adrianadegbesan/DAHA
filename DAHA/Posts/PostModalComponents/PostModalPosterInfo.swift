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
        } //:HStack
        .padding(.leading, 10)
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
