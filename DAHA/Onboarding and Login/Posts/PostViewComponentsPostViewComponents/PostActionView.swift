//
//  PostActionView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/29/23.
//

import SwiftUI

struct PostActionView: View {
    
    @State var post: PostModel
    @Binding var saved: Bool
    
    var body: some View {
        HStack{
            Text(post.price)
                .font(.system(size: 20, weight: .bold))
                .layoutPriority(1)
            
            
            BuyButton(post: post)
                .layoutPriority(1)
            
            Spacer()
            
            BookmarkButton(post: post, saved: $saved)
        }
    }
}

struct PostActionView_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [])
        PostActionView(post:post , saved: .constant(false))
    }
}
