//
//  PostModalDescription.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/31/23.
//

import SwiftUI

struct PostModalDescription: View {
    @State var post: PostModel
    var images = ["GreenBike", "GreenBike2", "GreenBike3"]
    
    var body: some View {
        VStack{
            HStack{
                Text(post.title)
                    .lineLimit(1)
                    .font(.system(size: 25, weight: .bold))
                
                Spacer()
                
                Text(post.price)
                    .lineLimit(1)
                    .font(.system(size: 22, weight: .bold))
            } //:HStack
            
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
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .padding(2.3)
            .frame(width: screenWidth * 0.92, height: screenHeight * 0.35)
            .overlay (
                RoundedRectangle(cornerRadius: 15)
                    .strokeBorder(lineWidth: 2)
            )
            
            HStack{
                Text(post.description)
                    .lineLimit(4)
            }
            .padding(.bottom, 10)
        }
    }
}

struct PostModalDescription_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [])
        PostModalDescription(post: post)
    }
}
