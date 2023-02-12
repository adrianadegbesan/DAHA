//
//  PostImageView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/29/23.
//

import SwiftUI



struct PostImageView: View {
   @State var post: PostModel
   @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        if !post.imageURLs.isEmpty{
            TabView {
                ForEach(post.imageURLs, id: \.self) { item in
                    AsyncImage(url: URL(string: item), transaction: Transaction(animation: .easeIn(duration: 0.3))) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .cornerRadius(15)
                                .clipped()
//                                .transition(.scale)
                        case .failure(_):
                            Image("Logo").overlay(Rectangle().stroke(colorScheme == .dark ? .white : .clear)).opacity(0.8)
                        case .empty:
                            ProgressView()
                        @unknown default:
                            ProgressView()
                        }
                    }
                 
              } //: LOOP
            } //: TAB
            .tabViewStyle(PageTabViewStyle())
            .cornerRadius(15)
//            .padding(2.7)
            .frame(width: screenWidth * 0.385, height: screenHeight * 0.21)
            .overlay (
                RoundedRectangle(cornerRadius: 15)
                    .strokeBorder(lineWidth: 1.5)
//                    .strokeBorder(Color(hex: category_colors[post.category] ?? "000000"), lineWidth: 1.5)
            )
            .clipped()
        } else {
            Image(systemName: category_images[post.category] ?? "bag.fill")
                .scaleEffect(5)
                .frame(width: screenWidth * 0.385, height: screenHeight * 0.21)
                .foregroundColor(Color(hex: category_colors[post.category] ?? "000000") )
                .overlay (
                    RoundedRectangle(cornerRadius: 15)
                        .strokeBorder((colorScheme != .dark && post.category != "General") ? Color(hex: category_colors[post.category] ?? "000000"): .white , lineWidth: 1)
                )
        }
      
      
    }
}

struct PostImageView_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "", keywordsForLookup: [])
        PostImageView(post: post)
    }
}
