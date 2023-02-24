//
//  DeleteButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/1/23.
//

import SwiftUI

struct DeleteButton: View {
    @State var post: PostModel
    @State var isPresented: Bool = false
    @State var deleted: Bool = false
    @State var error_alert : Bool = false
    @State var delete_alert : Bool = false
    @EnvironmentObject var firestoreManager : FirestoreManager
    
    var body: some View {
        Button(action: {
            isPresented = true
        }){
            Image(systemName: "trash")
                .font(.system(size: 23, weight: .bold))
                .foregroundColor(.red)
        }
        .alert("Delete Post", isPresented: $isPresented, actions: {
            Button("Delete", role: .destructive, action: {
                Task{
                    await firestoreManager.deletePost(post: post, deleted: $deleted, error_alert: $error_alert)
                    
                    if deleted {
//
                        if post.type == "Listing"{
                            firestoreManager.getListings()
                            await firestoreManager.userPosts()
                            
                            
                        } else if post.type == "Request"{
                            firestoreManager.getRequests()
                            await firestoreManager.userPosts()
                        }
                    }
                }
            })
        }, message: {
            Text("Are you sure you want to delete this post?")
        })
        .alert("Unable to Delete Post", isPresented: $error_alert, actions: {}, message: {Text("Please check your network connection and try again later ")})
        .alert("Post Successfully Deleted", isPresented: $delete_alert, actions: {}, message: {Text("Your post has been deleted")})
    }
}

struct DeleteButton_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "", keywordsForLookup: [])
        DeleteButton(post: post)
    }
}
