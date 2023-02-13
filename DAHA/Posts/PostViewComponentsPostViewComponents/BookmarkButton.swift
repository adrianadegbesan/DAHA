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
    @State var save_alert: Bool = false
    @State var unsave_alert: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var firestoreManager : FirestoreManager
    
    var body: some View {
        
        Button(action: {
            SoftFeedback()
            if saved {
                Task{
                    let result = await firestoreManager.unsavePost(post: post)
                    if result {
                        withAnimation{
                            saved.toggle()
                        }
                        await firestoreManager.getSaved()
                        if post.type == "Listing"{
                            await firestoreManager.getListings()
                        } else {
                            await firestoreManager.getSaved()
                        }
                    } else {
                        unsave_alert = true
                    }
                }
               
            } else {
                Task{
                    let result = await firestoreManager.savePost(post: post)
                    if result {
                        withAnimation{
                            saved.toggle()
                        }
                        await firestoreManager.getSaved()
                        if post.type == "Listing"{
                            await firestoreManager.getListings()
                        } else {
                            await firestoreManager.getSaved()
                        }
                    } else {
                        save_alert = true
                    }
                }
            }
            
        }){
            if saved{
                Image(systemName: "bookmark.fill")
                    .minimumScaleFactor(0.05)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color(hex: deepBlue))
            } else {
                Image(systemName: "bookmark")
                    .minimumScaleFactor(0.05)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            }
        }
        .onAppear{
            let cur_id = firestoreManager.userId
            if cur_id != nil{
                if post.savers.contains(cur_id!){
                    saved = true
                }
            }
        }
        .alert("Error Saving Post", isPresented: $save_alert, actions: {}, message: {Text("Please check your network connection and try again later")})
        .alert("Error Unsaving Post", isPresented: $unsave_alert, actions: {}, message: {Text("Please check your network connection and try again later")})
        
    }
}

struct BookmarkButton_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "", keywordsForLookup: [])
        BookmarkButton(post: post, saved: .constant(false))
    }
}
