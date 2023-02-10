//
//  TypeIcon.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/9/23.
//

import SwiftUI

struct TypeIcon: View {
    
    @Binding var post: PostModel
    @Binding var selected : String
    @State var type : String
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        if (selected == type){
            Button(action: {
                SoftFeedback()
                selected = ""
                post.type = ""
            }) {
                Text(type.uppercased())
                    .lineLimit(1)
                    .foregroundColor(.blue)
                    .font(.system(size: 10, weight: .bold))
                    .padding(10)
                    .background(Capsule().stroke(.blue, lineWidth: 5))
                    .padding(.trailing, 10)
            }
            
        } else {
            Button(action: {
                LightFeedback()
                selected = type
                post.type = type
            }) {
                Text(type.uppercased())
                    .lineLimit(1)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .font(.system(size: 10, weight: .bold))
                    .padding(10)
                    .background(Capsule().stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
                    .padding(.trailing, 10)
            }
            
        }

    }
}

struct TypeIcon_Previews: PreviewProvider {
    static var previews: some View {
        let post: PostModel = PostModel(title: "", userID: "", username: "", description: "", condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [], type: "")
        
        TypeIcon(post: .constant(post), selected: .constant("Request"), type: "Request")
    }
}
