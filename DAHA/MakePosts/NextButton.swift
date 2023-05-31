//
//  NextButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/7/23.
//

import SwiftUI

struct NextButton: View {
    
    @Binding var post: PostModel
    @Binding var images: [UIImage]
    @Binding var post_created: Bool
    @Binding var category : String
    @Binding var type: String
    
    @State private var error_alert : Bool = false
    @State private var error_message: String = ""
    @State private var shouldNavigate: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @State private var post_temp : Bool = false
    
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
                post.id = UUID().uuidString
                
                shouldNavigate = true
            }
            
        }){
            Text("Next")
                .font(.system(size: 18, weight: .bold))
                .scaleEffect(1.1)
            
            NavigationLink(destination: PostConfirmationScreen(post: $post, images: $images, post_created: $post_created), isActive: $shouldNavigate){
                EmptyView()
            }
            .isDetailLink(false)
            .buttonStyle(.plain)
        }
        .buttonStyle(.plain)
        .alert("Cannot Create Post", isPresented: $error_alert, actions: {}, message: {Text(error_message)})
    }
}

struct NextButton_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted, gave me alot of miles but kinda creaky sometimes", postedAt: nil, condition: "Good", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "", keywordsForLookup: [], reporters: [])
        let images: [UIImage] = []
        NextButton(post: .constant(post), images: .constant(images), post_created: .constant(false), category: .constant(""), type: .constant(""))
    }
}
