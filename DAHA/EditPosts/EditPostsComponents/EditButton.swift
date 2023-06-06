//
//  EditButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 6/4/23.
//

import SwiftUI

struct EditButton: View {
    @Binding var post: PostModel
    @Binding var originalPost: PostModel
    @Binding var images: [UIImage]
    @Binding var uploading: Bool
    @Binding var category : String
    @Binding var type: String
    
    @State private var error_alert : Bool = false
    @State private var error_message: String = ""
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var firestoreManager : FirestoreManager
    @State private var isPresented : Bool = false
    
    @AppStorage("username") var username_system: String = ""
    
    var body: some View {
        Button(action:{
            
            post.category = category
            post.type = type
            post.username = username_system
            
            if post.category.replacingOccurrences(of: " ", with: "") == "" {
                error_message = "Please choose a category"
                error_alert = true
            } else if post.type.replacingOccurrences(of: " ", with: "") == "" {
                error_message = "Please select a post type"
                error_alert = true
            } else if post.condition.replacingOccurrences(of: " ", with: "") == ""{
                error_message = "Please select an item condition"
                error_alert = true
            } else if post.title.replacingOccurrences(of: " ", with: "") == "" {
                error_message = "Please enter a title"
                error_alert = true
            } else {
                
                if post.price == "." {
                    post.price = "Free"
                }
                
                
                if post.price.last != nil {
                    if post.price.last! == "." {
                        post.price.removeLast()
                    }
                }
                
                if post.price.first != nil{
                    if post.price.first! == "."{
                        post.price = "0" + post.price
                    }
                }
                if post.price.replacingOccurrences(of: " ", with: "") == "" {
                    post.price = "Free"
                } else if Double(post.price) == 0 {
                    post.price = "Free"
                }
                post.description = post.description.trimmingCharacters(in: .whitespacesAndNewlines)
                post.title = post.title.trimmingCharacters(in: .whitespacesAndNewlines)
                post.keywordsForLookup = post.title.generateStringSequence()
                
                isPresented = true
            }
            
        }){
            Text("Edit")
                .font(.system(size: 19, weight: .bold))
                .foregroundColor(Color(hex: deepBlue))
//                .scaleEffect(1.1)
            
        }
        .buttonStyle(.plain)
        .alert("Confirm Post Edit", isPresented: $isPresented, actions: {
            Button("Cancel", action: {})
            
            Button("Edit", action: {
                hideKeyboard()
                uploading = true
                Task {
                    try await Task.sleep(nanoseconds: 0_800_000_000)
                    let result = await firestoreManager.editPost(post: $post, images: images)
                    if result {
                        withAnimation {
                            uploading = false
                            originalPost = post
                            withAnimation{
                                if post.type == "Listing"{
                                    if let index = firestoreManager.listings.firstIndex(where: { $0.id == post.id }) {
                                        firestoreManager.listings[index] = post
                                    }

                                    if let index = firestoreManager.listings_filtered.firstIndex(where: { $0.id == post.id }){
                                        firestoreManager.listings_filtered[index] = post
                                    }

                                    if let index = firestoreManager.my_posts.firstIndex(where: { $0.id == post.id }) {
                                        firestoreManager.my_posts[index] = post
                                    }

                                    if let index = firestoreManager.search_results.firstIndex(where: { $0.id == post.id }) {
                                        firestoreManager.search_results[index] = post
                                    }

                                } else if post.type == "Request"{
                                    if let index = firestoreManager.requests.firstIndex(where: { $0.id == post.id }) {
                                        firestoreManager.requests[index] = post
                                    }

                                    if let index = firestoreManager.requests_filtered.firstIndex(where: { $0.id == post.id }){
                                        firestoreManager.requests_filtered[index] = post
                                    }

                                    if let index = firestoreManager.my_posts.firstIndex(where: { $0.id == post.id }) {
                                        firestoreManager.my_posts[index] = post
                                    }

                                    if let index = firestoreManager.search_results.firstIndex(where: { $0.id == post.id }) {
                                        firestoreManager.search_results[index] = post
                                    }
                                }

                            }
                        }
                        dismiss()
                    } else {
                        withAnimation {
                            uploading = false
                        }
                        error_alert = true
                    }
                }
            })
        }, message: {Text("Are you sure you want to edit this post?")})
        .alert("Cannot Edit Post", isPresented: $error_alert, actions: {}, message: {Text("Unable to edit post, please check your network connection adn try again later")})
    }
}

//struct EditButton_Previews: PreviewProvider {
//    static var previews: some View {
//        EditButton()
//    }
//}
