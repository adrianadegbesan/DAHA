//
//  PostView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/28/23.
//

import SwiftUI

struct PostView: View {
    @State var post: PostModel
    @State var saved = false
    
    @State private var shouldNavigate : Bool = false
    @State private var buyNavigate : Bool = false
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                
                PosterInfoView(post: post)
                
                CategoryView(post: post)
                
                PostDescriptionView(post: post)
                
                PostActionView(post: post, saved: $saved)
                    .layoutPriority(1)
            }
            
            Spacer()
            
            PostImageView(post: post)
            
            NavigationLink(destination: PostScreen(post: post, saved: $saved), isActive: $shouldNavigate){
                EmptyView()
            }
                
            NavigationLink(destination: MainScreen(), isActive: $buyNavigate){
                EmptyView()
            }
            
        } //HStack
        .frame(width: screenWidth * 0.89, height: screenHeight * 0.22)
        .padding()
        .overlay (
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color(hex: category_colors[post.category] ?? "000000"), lineWidth: 2)
                .shadow(radius: 3, y: 1)
        )
        .onTapGesture(count: 2) {
            buyNavigate = true
        }
        .onTapGesture {
            shouldNavigate = true
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [])
        NavigationView{
            PostView(post: post)
        }
    }
}
