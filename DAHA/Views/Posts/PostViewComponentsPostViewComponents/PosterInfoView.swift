//
//  PosterInfoView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/29/23.
//

import SwiftUI

struct PosterInfoView: View {
    
    @State var post: PostModel
    var body: some View {
        HStack{
            Text("@\(post.username)")
                .fontWeight(.semibold)
                .lineLimit(1)
                .foregroundColor(.gray)
            
            Spacer()
            
            //Sort out timestamp
            //Post.postedAt
            
            Text("5 mins ago")
                .fontWeight(.semibold)
                .lineLimit(1)
                .layoutPriority(1)
                .foregroundColor(.gray)
        }
        .padding(.bottom, 1)
    }
}

struct PosterInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [])
        PosterInfoView(post: post)
    }
}
