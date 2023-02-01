//
//  PostModalPostActions.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/31/23.
//

import SwiftUI

struct PostModalPostActions: View {
    @State var post: PostModel
    @Binding var saved: Bool
    @State var owner: Bool
    
    var body: some View {
        HStack{
            if owner {
                Spacer()
                DeleteButton(post: post)
                    .scaleEffect(1.2)
            } else {
                BookmarkButton(post: post, saved: $saved)
                    .scaleEffect(1.2)
                Spacer()
                BuyButton(post: post)
                    .scaleEffect(1.2)
            }
        }
    }
}

struct PostModalPostActions_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [])
        PostModalPostActions(post: post, saved: .constant(false), owner: true)
    }
}
