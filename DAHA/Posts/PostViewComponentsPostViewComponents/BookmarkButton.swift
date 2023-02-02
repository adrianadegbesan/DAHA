//
//  BookmarkButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/29/23.
//

import SwiftUI

struct BookmarkButton: View {
    
    @State var post: PostModel
    @Binding var saved: Bool
    
    var body: some View {
        
        if !saved{
            Image(systemName: "bookmark")
                .font(.system(size: 23, weight: .bold))
                .onTapGesture {
                    //Save Function
                    saved.toggle()
                }
        } else {
            Image(systemName: "bookmark.fill")
                .font(.system(size: 23, weight: .bold))
                .foregroundColor(Color(hex: deepBlue))
                .onTapGesture {
                    //Save Function
                    saved.toggle()
                }
        }
        //ALERT
    }
}

struct BookmarkButton_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [])
        BookmarkButton(post: post, saved: .constant(false))
    }
}