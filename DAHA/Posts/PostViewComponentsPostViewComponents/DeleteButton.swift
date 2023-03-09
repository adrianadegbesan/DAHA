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
    @State var modal : Bool?
    @EnvironmentObject var firestoreManager : FirestoreManager
    @Environment(\.dismiss) var dismiss
    
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
                         
                        withAnimation{
                            if post.type == "Listing"{
                                if let index = firestoreManager.listings.firstIndex(where: { $0.id == post.id }) {
                                    firestoreManager.listings.remove(at: index)
                                }
                                
                                
                            } else if post.type == "Request"{
                                if let index = firestoreManager.requests.firstIndex(where: { $0.id == post.id }) {
                                    firestoreManager.requests.remove(at: index)
                                }
                            }
                              if let index = firestoreManager.my_posts.firstIndex(where: { $0.id == post.id }) {
                                  firestoreManager.my_posts.remove(at: index)
                              }
                            
                            if modal != nil{
                                if modal! {
                                    dismiss()
                                }
                            }
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
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "", keywordsForLookup: [], reporters: [])
        DeleteButton(post: post)
    }
}
