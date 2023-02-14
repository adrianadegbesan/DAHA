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
    @State var owner: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack{
            (Text(post.price == "Free" ? "" : "$") + Text(post.price))
//                .foregroundColor(.black)
                .lineLimit(1)
                .minimumScaleFactor(0.3)
                .font(.system(size: post.price == "Free" ? 18 : 20, weight: .bold))
                .layoutPriority(1)
            
            if owner == true {
                Spacer()
//                Image(systemName: "checkmark.circle")
//                    .foregroundColor(.green)
//                    .font(.system(size: 23, weight: .semibold))
//                    .background(Circle().fill(.white))
//                    .overlay(Circle().stroke(colorScheme == .dark ? .white : .black, lineWidth: 3))
//                    .padding(.trailing,8)
//                Spacer()
                DeleteButton(post: post)
                
            } else {
                BuyButton(post: post)
                    .layoutPriority(1)
                Spacer()
                BookmarkButton(post: post, saved: $saved)
            }
          
        }
    }
}

struct PostActionView_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "100", imageURLs: [], channel: "Stanford", savers: [], type: "Request", keywordsForLookup: [])
        PostActionView(post:post , saved: .constant(false), owner: true)
            .environmentObject(FirestoreManager())
    }
}
