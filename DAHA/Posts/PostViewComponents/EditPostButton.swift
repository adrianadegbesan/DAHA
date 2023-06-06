//
//  EditPostButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 6/4/23.
//

import SwiftUI

struct EditPostButton: View {
    @Binding var post: PostModel
    @State private var shouldNavigate: Bool = false
    
    var body: some View {
        Button(action: {
            shouldNavigate = true
        }){
            if #available(iOS 16, *){
                Image(systemName: "pencil.line")
                    .font(.system(size: 23, weight: .heavy))
                    .foregroundColor(Color(hex: deepBlue))
            } else {
                Image(systemName: "pencil")
                    .font(.system(size: 23, weight: .heavy))
                    .foregroundColor(Color(hex: deepBlue))
            }
            
            
            NavigationLink(destination: EditPostsScreen(post: post, originalPost: $post), isActive: $shouldNavigate){
                EmptyView()
            }
        }
        .buttonStyle(.plain)
    }
}

//struct EditPostButton_Previews: PreviewProvider {
//    static var previews: some View {
//        EditPostButton()
//    }
//}
