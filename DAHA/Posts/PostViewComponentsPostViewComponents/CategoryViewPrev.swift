//
//  CategoryViewPrev.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/1/23.
//

import SwiftUI

struct CategoryViewPrev: View {
    @State var post: PostModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack{
            
//            Label(post.category.uppercased(), systemImage: category_images[post.category] ?? "")
            (Text(Image(systemName: category_images[post.category] ?? "")) + Text(" ") + Text(post.category.uppercased()))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .font(.system(size: 9, weight: .bold))
                .minimumScaleFactor(0.3)
                .foregroundColor(.white)
                .layoutPriority(1)
                .padding(10)
                .background(Capsule().fill(Color(hex: category_colors[post.category] ?? "000000")))
                .overlay((post.category == "General" && colorScheme == .dark) ? Capsule().stroke(.white, lineWidth: 2) : Capsule().stroke(.clear, lineWidth: 3))
                .padding(.trailing, 6)
            
            Text(post.condition.uppercased())
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .font(.system(size: 9, weight: .bold))
                .minimumScaleFactor(0.3)
                .padding(10)
                .background(Capsule().stroke(lineWidth: 2))
                .padding(.trailing, 10)
            
            Spacer()
            
        }
    }
}

struct CategoryViewPrev_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "", keywordsForLookup: [])
        CategoryViewPrev(post: post)
    }
}
