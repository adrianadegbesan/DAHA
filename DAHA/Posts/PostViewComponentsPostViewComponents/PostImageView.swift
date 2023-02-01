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
          } //: LOOP
        } //: TAB
        .tabViewStyle(PageTabViewStyle())
//        .indexViewStyle(.page(backgroundDisplayMode: .automatic))
        .padding(3)
        .frame(width: screenWidth * 0.385, height: screenHeight * 0.21)
        .overlay (
            RoundedRectangle(cornerRadius: 15)
                .strokeBorder(.gray.opacity(0.5), lineWidth: 4)
        )
    }
}

struct PostImageView_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [])
        PostImageView(post: post)
    }
}
