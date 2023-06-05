//
//  PostModalPosterInfo.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/31/23.
//

import SwiftUI
import Firebase
import Shimmer

struct PostModalPosterInfo: View {
    @Binding var post: PostModel
    @Environment(\.colorScheme) var colorScheme
    @State private var shouldNavigate: Bool = false
    @EnvironmentObject var firestoreManager : FirestoreManager

    
    var body: some View {
        HStack{
            Text("@\(post.username)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .onTapGesture {
                    firestoreManager.user_temp_posts.removeAll()
                    Task {
                        await firestoreManager.getUserTempPosts(userId: post.userID)
                    }
                    shouldNavigate = true
                }
            
            Image(systemName:"circle.fill")
                .font(.system(size: 3.8, weight: .bold))
                .foregroundColor(.secondary)
            
            Text(post.postedAt?.dateValue().timeAgoDisplay() ?? "")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.secondary)
            Spacer()
            
            (Text(Image(systemName: type_images[post.type] ?? "")) + Text(" ") + Text(post.type.uppercased()))
                .lineLimit(1)
                .font(.system(size: 15, weight: .heavy))
                .layoutPriority(1)
                .padding(.trailing, 10)
                .foregroundColor(post.price == "Sold" || post.price == "Satisfied" ? Color(hex: color_new) : post.borrow != nil ? (post.borrow! ? Color(hex: category_colors["Borrow"] ?? "000000") : Color(hex: deepBlue) ) : Color(hex: deepBlue))
                .modifier(shimmerOnTap())
            
            NavigationLink(destination: UserPostsScreen(username: post.username, userId: post.userID), isActive: $shouldNavigate){
                EmptyView()
            }
            .buttonStyle(.plain)

            }
        .padding(.leading, 12)
        } //:HStack
       
    }

struct PostModalPosterInfo_Previews: PreviewProvider {
    static var previews: some View {
        let startTime = Date.now
        let startTimestamp: Timestamp = Timestamp(date: startTime)
        
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: startTimestamp, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "Request", keywordsForLookup: [], reporters: [])
        PostModalPosterInfo(post: .constant(post))
    }
}
