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
                    .minimumScaleFactor(0.5)
                    .font(.system(size: 19, weight: .bold))
                    
                   
                
                Spacer()
                
                Text("$\(post.price)")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .font(.system(size: 16, weight: .bold))
                 
            } //:HStack
            .padding(.leading, 10)
            .padding(.trailing, 10)

            if !post.imageURLs.isEmpty {
                TabView {
                    //post.imageURLs
                    ForEach(post.imageURLs, id: \.self) { item in
                        AsyncImage(url: URL(string: item), transaction: Transaction(animation: .spring(response:0.5, dampingFraction: 0.6, blendDuration: 0.25))) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .clipped()
                                    .transition(.scale)
                            case .failure(_):
                                Image("Logo").opacity(0.8)
                            case .empty:
                                Image("Logo").opacity(0.8)
                            @unknown default:
                                ProgressView()
                            }
                        }
                  } //: LOOP
                } //: TAB
                .tabViewStyle(PageTabViewStyle())
    //            .cornerRadius(15)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .padding(2.3)
                .frame(width: screenWidth, height: screenHeight * 0.35)
    //            .frame(width: screenWidth * 0.92, height: screenHeight * 0.35)
                .overlay (
    //                RoundedRectangle(cornerRadius: 15)
                    Rectangle()
                        .strokeBorder(lineWidth: 1.5)
                )
                .clipped()

            } else {
                Image(systemName: category_images[post.category] ?? "bag.fill")
                    .scaleEffect(10)
                    .frame(width: screenWidth, height: screenHeight * 0.35)
                    .foregroundColor(Color(hex: category_colors[post.category] ?? "000000") )
                    .overlay (
                        Rectangle()
                            .strokeBorder(Color(hex: category_colors[post.category] ?? "000000"), lineWidth: 1.5)
                    )
            }
            
            HStack{
                Text(post.description)
            }
            .padding(.bottom, 10)
        }
    }
}

struct PostModalDescription_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "100", imageURLs: [], channel: "Stanford", savers: [])
        PostModalDescription(post: post)
    }
}
