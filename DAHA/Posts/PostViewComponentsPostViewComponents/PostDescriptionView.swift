//
//  PostDescriptionView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/29/23.
//

import SwiftUI

struct PostDescriptionView: View {
    
    @State var post: PostModel
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(post.title)
                
                    .lineLimit(1)
                    .font(.system(size: 20, weight: .bold))
            }
            .padding(.bottom, 1)
            
            HStack{
                Text(post.description)
                    .font(.system(size: 12.5))
                    .lineLimit(2)
                    
            }
            .padding(.bottom, 1)
            
        }
//        .foregroundColor(.black)
    }
}

struct PostDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "")
        PostDescriptionView(post: post)
    }
}
