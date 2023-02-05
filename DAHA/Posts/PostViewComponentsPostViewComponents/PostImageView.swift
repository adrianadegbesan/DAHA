//
//  PostImageView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/29/23.
//

import SwiftUI



struct PostImageView: View {
   @State var post: PostModel
   var images = ["GreenBike", "GreenBike2", "GreenBike3"]
    
    var body: some View {
        TabView {
            //post.imageURLs
            ForEach(images, id: \.self) { item in
            //AsyncImage
              Image(item)
              .resizable()
              .cornerRadius(15)
              .clipped()
          } //: LOOP
        } //: TAB
        .tabViewStyle(PageTabViewStyle())
        .cornerRadius(15)
        .padding(2.7)
        .frame(width: screenWidth * 0.385, height: screenHeight * 0.21)
        .overlay (
            RoundedRectangle(cornerRadius: 15)
                .strokeBorder(Color(hex: category_colors[post.category] ?? "000000"), lineWidth: 3.75)
        )
        .clipped()
      
    }
}

struct PostImageView_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [])
        PostImageView(post: post)
    }
}
