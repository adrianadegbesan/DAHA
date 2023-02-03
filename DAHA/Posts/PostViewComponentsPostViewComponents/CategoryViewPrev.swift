//
//  CategoryViewPrev.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/1/23.
//

import SwiftUI

struct CategoryViewPrev: View {
    @State var post: PostModel
    
    var body: some View {
        HStack{
            
            Label(post.category.uppercased(), systemImage: category_images[post.category] ?? "")
                .lineLimit(1)
                .foregroundColor(.white)
                .font(.system(size: 7.5, weight: .bold))
                .padding(10)
                .background(Capsule().fill(Color(hex: category_colors[post.category] ?? "000000")))
                .padding(.trailing, 10)
            
            Text(post.condition.uppercased())
                .lineLimit(1)
//                .foregroundColor(.white)
                .font(.system(size: 7.5, weight: .bold))
                .padding(10)
                .background(Capsule().stroke(lineWidth: 2))
                .padding(.trailing, 10)
            
            Spacer()
            
        }
    }
}

struct CategoryViewPrev_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [])
        CategoryViewPrev(post: post)
    }
}
