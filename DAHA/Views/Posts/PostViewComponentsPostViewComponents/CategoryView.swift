//
//  CategoryView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/29/23.
//

import SwiftUI

struct CategoryView: View {
    
    @State var post: PostModel
    @State var reported: Bool = false
    
    var body: some View {
        HStack{
            
            Text(post.category.uppercased())
                .lineLimit(1)
                .foregroundColor(.white)
                .font(.system(size: 10, weight: .bold))
                .padding(10)
                .background(Capsule().fill(Color(hex: category_colors[post.category] ?? "000000")))
                .padding(.trailing, 10)
            
            Text(post.condition.uppercased())
                .lineLimit(1)
                .foregroundColor(.white)
                .font(.system(size: 10, weight: .bold))
                .padding(10)
                .background(Capsule().fill(.gray))
                .padding(.trailing, 10)
            
            Spacer()
            
            ReportButton(post: post, reported: $reported)
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [])
        CategoryView(post: post)
    }
}
