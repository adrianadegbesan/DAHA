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
    @Binding var post_edited: Bool
    @Binding var category : String
    @Binding var type: String
    
    @State private var error_alert : Bool = false
    @State private var error_message: String = ""
    @Environment(\.colorScheme) var colorScheme
    
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
                
                
            }
            
        }){
            Text("Edit")
                .font(.system(size: 19, weight: .bold))
                .foregroundColor(Color(hex: deepBlue))
//                .scaleEffect(1.1)
            
        }
        .buttonStyle(.plain)
        .alert("Cannot Edit Post", isPresented: $error_alert, actions: {}, message: {Text(error_message)})
    }
}

//struct EditButton_Previews: PreviewProvider {
//    static var previews: some View {
//        EditButton()
//    }
//}
