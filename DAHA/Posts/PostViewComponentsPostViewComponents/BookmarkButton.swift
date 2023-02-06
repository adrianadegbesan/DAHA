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
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        if !saved{
            Button(action: {
                LightFeedback()
                saved.toggle()
            }) {
                Image(systemName: "bookmark")
                    .minimumScaleFactor(0.05)
                    .font(.system(size: 22, weight: .bold))
            }
            .foregroundColor(colorScheme == .dark ? .white : .black)
        } else {
            Button(action: {
                LightFeedback()
                saved.toggle()
                
            }) {
                Image(systemName: "bookmark.fill")
                    .font(.system(size: 23, weight: .bold))
                    .foregroundColor(Color(hex: deepBlue))
            }
            .foregroundColor(.black)
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
