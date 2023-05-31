//
//  LendButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 4/26/23.
//

import SwiftUI

struct LendButton: View {
    @Binding var post: PostModel
    @Binding var type: String
    @State private var selected : Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: {
                SoftFeedback()
                if post.borrow == nil {
                    post.borrow = true
                } else {
                    post.borrow?.toggle()
                }
                if post.borrow != nil {
                    selected = post.borrow!
                }
        }) {
            (Text(Image(systemName: type_images["Borrow"] ?? "")) + Text(" ") + Text("Lend"))
                .lineLimit(1)
                .foregroundColor(selected ? Color(hex: "F37A35"): colorScheme == .dark ? .white : .black)
                .font(.system(size: 13, weight: .bold))
                .padding(10)
                .background(Capsule().stroke(selected ? Color(hex: "F37A35"): colorScheme == .dark ? .white : .black, lineWidth: selected ? 5 : 2))
                .padding(.trailing, 10)
        }
        .buttonStyle(.plain)
//        .onChange(of: type){ value in
//            if value != "Listing"{
//                selected = false
//                post.borrow = false
//            }
//        }
        .onAppear{
            if post.borrow != nil{
                if post.borrow!{
                    selected = true
                }
            }
        }
    }
}

struct LendButton_Previews: PreviewProvider {
    static var previews: some View {
        let post: PostModel = PostModel(title: "", userID: "", username: "", description: "", condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [], type: "", keywordsForLookup: [], reporters: [])
        LendButton(post: .constant(post), type: .constant("Request"))
    }
}
