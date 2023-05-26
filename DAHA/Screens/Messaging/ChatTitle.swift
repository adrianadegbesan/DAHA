//
//  ChatTitle.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 5/24/23.
//

import SwiftUI
import Firebase

struct ChatTitle: View {
    @State var post: PostModel
    @State var receiver: String
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack{
            Text(Image(systemName: category_images[post.category] ?? "bag.fill"))
                .fontWeight(.bold)
                .foregroundColor(colorScheme == .dark && post.category == "General" ? .white : Color(hex: category_colors[post.category] ?? "ffffff") )
                .padding()
                .overlay(
                    Circle()
                        .stroke(lineWidth: 2)
                        .foregroundColor(colorScheme == .dark && post.category == "General" ? .white : Color(hex: category_colors[post.category] ?? "ffffff") )
                )
            Text("@\(receiver)")
        }
    }
}

struct ChatTitle_Previews: PreviewProvider {
    static var previews: some View {
        let calendar = Calendar.current
        let startTime = calendar.date(byAdding: .day, value: -2, to: Date())
        let startTimestamp: Timestamp = Timestamp(date: startTime!)
        
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted, gave me alot of miles but kinda creaky sometimes", postedAt: startTimestamp, condition: "Good", category: "Bikes", price: "100", imageURLs: [], channel: "Stanford", savers: [], type: "Listing", keywordsForLookup: [], reporters: [])
        
        ChatTitle(post: post, receiver: "Adrian")
    }
}
