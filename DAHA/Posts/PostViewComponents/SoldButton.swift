//
//  SoldButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 5/15/23.
//

import SwiftUI

struct SoldButton: View {
    @Binding var post: PostModel
    @Binding var price: String
    @State private var isPresented: Bool = false
    @State private var deleted: Bool = false
    @State private var error_alert : Bool = false
    @State private var delete_alert : Bool = false
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
        .buttonStyle(.plain)
        .alert(post.type == "Listing" ?  "Mark Listing as Sold": "Mark Request as Satisfied", isPresented: $isPresented, actions: {
            Button("Cancel", action: {})
            
            Button("Confirm", action: {
                Task{
                   
                    
                    let confirmSuccess = await firestoreManager.confirmPost(post: post)

                    if confirmSuccess {
                        withAnimation{
                            if post.type == "Listing"{
                                post.price = "Sold"
                                if let index = firestoreManager.listings.firstIndex(where: { $0.id == post.id }) {
                                    firestoreManager.listings[index].price = "Sold"
                                }

//                                if let index = firestoreManager.listings_filtered.firstIndex(where: { $0.id == post.id }){
//                                    firestoreManager.listings_filtered[index].price = "Sold"
//                                }

                                if let index = firestoreManager.my_posts.firstIndex(where: { $0.id == post.id }) {
                                    firestoreManager.my_posts[index].price = "Sold"
                                }

                                if let index = firestoreManager.search_results.firstIndex(where: { $0.id == post.id }) {
                                    firestoreManager.search_results[index].price = "Sold"
                                }

                            } else if post.type == "Request"{
                                post.price = "Satisfied"
                                if let index = firestoreManager.requests.firstIndex(where: { $0.id == post.id }) {
                                    firestoreManager.requests[index].price = "Satisfied"
                                }

//                                if let index = firestoreManager.requests_filtered.firstIndex(where: { $0.id == post.id }){
//                                    firestoreManager.requests_filtered[index].price = "Satisfied"
//                                }

                                if let index = firestoreManager.my_posts.firstIndex(where: { $0.id == post.id }) {
                                    firestoreManager.my_posts[index].price = "Satisfied"
                                }

                                if let index = firestoreManager.search_results.firstIndex(where: { $0.id == post.id }) {
                                    firestoreManager.search_results[index].price = "Satisfied"
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
        .alert( post.type == "Listing" ? "Unable to Confirm Listing" : "Unable to Confirm Request", isPresented: $error_alert, actions: {}, message: {Text("Please check your network connection and try again later ")})
        
        
//        .alert("Post Successfully Confirmed", isPresented: $delete_alert, actions: {}, message: {post.type == "Listing" ? Text("Your listing has been marked as sold.") : Text("Your request has been marked as satisfied")
//        })
    }
}

struct SoldButton_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "Request", keywordsForLookup: [], reporters: [])
        SoldButton(post: .constant(post), price: .constant(""))
    }
}
