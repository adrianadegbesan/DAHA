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
    
    @State var error_alert : Bool = false
    @State var error_message: String = ""
    @State var shouldNavigate: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action:{

            if post.price.replacingOccurrences(of: " ", with: "") == "" {
                post.price = "Free"
            } else if post.category.replacingOccurrences(of: " ", with: "") == ""{
                error_message = "Please choose a category"
                error_alert = true
            } else if post.condition.replacingOccurrences(of: " ", with: "") == ""{
                error_message = "Please select an item condition"
                error_alert = true
            } else if post.title.replacingOccurrences(of: " ", with: "") == "" {
                error_message = "Please enter a title"
                error_alert = true
            } else {
                if Int(post.price) == 0 {
                    post.price = "Free"
                }
                post.description = post.description.replacingOccurrences(of: " ", with: "")
                post.title = post.title.replacingOccurrences(of: " ", with: "")
                shouldNavigate = true
            }
            
        }){
            Text("Next")
                .font(.system(size: 18, weight: .bold))
                .scaleEffect(1.1)
//                .padding(.bottom, 14)
//                .foregroundColor(colorScheme == .dark ? .white : .black)
            
            NavigationLink(destination: PostConfirmationScreen(post: $post, images: $images, post_created: $post_created), isActive: $shouldNavigate){
                EmptyView()
            }
        }
        .alert("Cannot Create Post", isPresented: $error_alert, actions: {}, message: {Text(error_message)})
    }
}

struct NextButton_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted, gave me alot of miles but kinda creaky sometimes", postedAt: nil, condition: "Good", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [])
        let images: [UIImage] = []
        NextButton(post: .constant(post), images: .constant(images), post_created: .constant(false))
    }
}