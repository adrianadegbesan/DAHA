//
//  BorrowButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/22/23.
//

import SwiftUI

struct BorrowButton: View {
    @Binding var post: PostModel
    @Binding var type: String
    @State var selected : Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: {
            if type == "Request" {
                SoftFeedback()
                if post.borrow == nil {
                    post.borrow = true
                } else {
                    post.borrow?.toggle()
                }
                if post.borrow != nil {
                    selected = post.borrow!
                }
            }
        }) {
            (Text(Image(systemName: type_images["Borrow"] ?? "")) + Text(" ") + Text("Borrow"))
                .lineLimit(1)
                .foregroundColor(selected ? .blue : colorScheme == .dark ? .white : .black)
                .font(.system(size: 13, weight: .bold))
                .padding(10)
                .background(Capsule().stroke(selected ? .blue : colorScheme == .dark ? .white : .black, lineWidth: selected ? 5 : 2))
                .padding(.trailing, 10)
        }
        .onChange(of: type){ value in
            if value != "Request"{
                selected = false
            }
            
        }
    }
}

struct BorrowButton_Previews: PreviewProvider {
    static var previews: some View {
        let post: PostModel = PostModel(title: "", userID: "", username: "", description: "", condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [], type: "", keywordsForLookup: [], reporters: [])
        
        BorrowButton(post: .constant(post), type: .constant("Request"))
    }
}