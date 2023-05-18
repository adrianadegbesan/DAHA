//
//  SoldButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 5/15/23.
//

import SwiftUI

struct SoldButton: View {
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
            Image(systemName: "checkmark.circle")
                .font(.system(size: 25, weight: .bold))
                .foregroundColor(.green)
        }
        .alert(post.type == "Listing" ?  "Mark Listing as Sold": "Mark Request as Satisfied", isPresented: $isPresented, actions: {
            Button("Cancel", action: {})
            
            Button("Confirm", action: {
                Task{
                    let delete_success = await firestoreManager.deletePost(post: post, deleted: $deleted, error_alert: $error_alert)
                    
//                    let confirmSuccess = await firestoreManager.confirmPost(post: post)
//
//                    if confirmSuccess {
//                        withAnimation{
//                            if post.type == "Listing"{
//                                if let index = firestoreManager.listings.firstIndex(where: { $0.id == post.id }) {
//                                    firestoreManager.listings[index].price = "Sold"
//                                }
//
//                                if let index = firestoreManager.listings_filtered.firstIndex(where: { $0.id == post.id }){
//                                    firestoreManager.listings_filtered[index].price = "Sold"
//                                }
//
//                                if let index = firestoreManager.my_posts.firstIndex(where: { $0.id == post.id }) {
//                                    firestoreManager.my_posts[index].price = "Sold"
//                                }
//
//                                if let index = firestoreManager.search_results.firstIndex(where: { $0.id == post.id }) {
//                                    firestoreManager.search_results[index].price = "Sold"
//                                }
//
//                            } else if post.type == "Request"{
//                                if let index = firestoreManager.requests.firstIndex(where: { $0.id == post.id }) {
//                                    firestoreManager.requests[index].price = "Satisfied"
//                                }
//
//                                if let index = firestoreManager.requests_filtered.firstIndex(where: { $0.id == post.id }){
//                                    firestoreManager.requests_filtered[index].price = "Satisfied"
//                                }
//
//                                if let index = firestoreManager.my_posts.firstIndex(where: { $0.id == post.id }) {
//                                    firestoreManager.my_posts[index].price = "Satisfied"
//                                }
//
//                                if let index = firestoreManager.search_results.firstIndex(where: { $0.id == post.id }) {
//                                    firestoreManager.search_results[index].price = "Satisfied"
//                                }
//                            }
//
//                        }
                    
                    if delete_success {

                        withAnimation{
                            if post.type == "Listing"{
                                if let index = firestoreManager.listings.firstIndex(where: { $0.id == post.id }) {
                                    firestoreManager.listings.remove(at: index)
                                }

                                if let index = firestoreManager.listings_filtered.firstIndex(where: { $0.id == post.id }){
                                    firestoreManager.listings_filtered.remove(at: index)
                                }

                            } else if post.type == "Request"{
                                if let index = firestoreManager.requests.firstIndex(where: { $0.id == post.id }) {
                                    firestoreManager.requests.remove(at: index)
                                }

                                if let index = firestoreManager.requests_filtered.firstIndex(where: { $0.id == post.id }){
                                    firestoreManager.requests_filtered.remove(at: index)
                                }
                            }
                            if let index = firestoreManager.my_posts.firstIndex(where: { $0.id == post.id }) {
                                firestoreManager.my_posts.remove(at: index)
                            }

                            if let index = firestoreManager.search_results.firstIndex(where: { $0.id == post.id }) {
                                firestoreManager.search_results.remove(at: index)
                            }





                            if modal != nil{
                                if modal! {
                                    dismiss()
                                }
                            }
                        }
                        
                    } else {
                        error_alert = true
                    }
                }
            })
            
        }, message: {
            post.type == "Listing" ? Text("Are you sure you want to mark this listing as sold? This action cannot be undone.") : Text("Are you sure you want to mark this request as satisfied? This action cannot be undone.")
        })
        .alert("Unable to Complete Post", isPresented: $error_alert, actions: {}, message: {Text("Please check your network connection and try again later ")})
        
        
//        .alert("Post Successfully Confirmed", isPresented: $delete_alert, actions: {}, message: {post.type == "Listing" ? Text("Your listing has been marked as sold.") : Text("Your request has been marked as satisfied")
//        })
    }
}

struct SoldButton_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "Request", keywordsForLookup: [], reporters: [])
        SoldButton(post: post)
    }
}
