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
                    .font(.system(size: 18.5, weight: .bold))
            }
            .padding(.bottom, 1)
            
            HStack{
                if #available(iOS 16.0, *) {
                    if post.description == ""{
//                        Text("DAHA")
                        Text(Image(systemName: category_images[post.category] ?? ""))
                            .font(.system(size: 14))
                            .lineLimit(2, reservesSpace: (2 != 0))
//                            .foregroundColor(.clear)
                    } else {
                        Text(post.description)
                            .font(.system(size: 11))
                            .lineLimit(2, reservesSpace: (2 != 0))
                    }
                        
                } else {
                    if post.description == "" {
                        Text(Image(systemName: category_images[post.category] ?? ""))
                            .font(.system(size: 14))
                        Spacer().frame(height: 3)
                    } else {
                        Text(post.description)
                            .font(.system(size: 11))
                            .lineLimit(2)
                    }
                }
                    
            }
            .padding(.bottom, 1)
            
        }
//        .foregroundColor(.black)
    }
}

struct PostDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "", keywordsForLookup: [], reporters: [])
        PostDescriptionView(post: post)
    }
}
