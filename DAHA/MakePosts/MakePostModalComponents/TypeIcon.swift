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
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        Button(action: {
            if selected != type {
                SoftFeedback()
                selected = type
                post.type = type
                dismiss()
                
            } else {
                SoftFeedback()
                selected = ""
                post.type = ""
                dismiss()
            }
        }) {
            ZStack{
                RoundedRectangle(cornerRadius: 23)
                    .fill(selected == type ? .black : .gray)
                    .frame(width: screenWidth * 0.6, height: screenHeight * 0.14)
                
                Label(type.uppercased(), systemImage: type_images[type] ?? "")
                    .font(
                        .system(size:30, weight: .bold)
                    )
                    .foregroundColor(.white)
            }
        }

    }
}

struct TypeIcon_Previews: PreviewProvider {
    static var previews: some View {
        let post: PostModel = PostModel(title: "", userID: "", username: "", description: "", condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [], type: "")
        
        TypeIcon(post: .constant(post), selected: .constant(""), type: "Request")
    }
}
