//
//  CategoryView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/29/23.
//

import SwiftUI

struct CategoryView: View {
    
    @State var post: PostModel
    @Binding var reported: Bool
    @State var owner: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack{
            
            
                (Text(Image(systemName: category_images[post.category] ?? "")) + Text(" ") + Text(post.category.uppercased()))
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                    .minimumScaleFactor(0.001)
                    .font(.system(size: 9, weight: .bold))
                    .layoutPriority(1)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Capsule().fill(Color(hex: category_colors[post.category] ?? "000000")))
                    .overlay(colorScheme == .dark ? Capsule().stroke(.white, lineWidth: 2) : Capsule().stroke(.black, lineWidth: 3))
                    .padding(.trailing, 6)
//            }
            
            
            Text(post.condition.uppercased())
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .minimumScaleFactor(0.001)
                .font(.system(size: 9, weight: .bold))
                .padding(10)
                .background(Capsule().stroke(lineWidth: colorScheme == .dark ? 2 : 3))
                .padding(.trailing, 10)
            
            Spacer()
            
            if !owner{
                ReportButton(post: post, reported: $reported)
            }
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "", keywordsForLookup: [])
        CategoryView(post: post, reported: .constant(false), owner: false)
    }
}
