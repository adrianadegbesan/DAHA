//
//  CategoryIconView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/1/23.
//

import SwiftUI

struct CategoryIconView: View {
    
    @State var category : String
    @Binding var selected : String
    @Binding var post : PostModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 23)
                .fill(selected == category ? Color(hex: category_colors[category] ?? "000000") : .gray)
                .frame(width: screenWidth * 0.4, height: screenHeight * 0.1)
            
            Text(category.uppercased())
                .font(
                    .system(size:20, weight: .bold)
                )
                .foregroundColor(.white)
        }
        
        .onTapGesture {
            if selected != category {
                selected = category
                post.category = category
                dismiss()
                
            } else {
                selected = ""
                post.category = ""
                dismiss()
            }
        }
    }
}

struct CategoryIconView_Previews: PreviewProvider {
    static var previews: some View {
        let post: PostModel = PostModel(title: "", userID: "", username: "", description: "", condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [])
        CategoryIconView(category: "Bikes", selected: .constant(""), post: .constant(post))
    }
}
