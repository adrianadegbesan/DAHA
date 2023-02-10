//
//  CategoryIcon.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/31/23.
//

import SwiftUI

struct CategoryIcon: View {
    
    @Binding var post: PostModel
    @State var category : String
    @Binding var selected : String
    
    var body: some View {
        
        if (selected == category){
            Text(category.uppercased())
                .lineLimit(1)
                .foregroundColor(.white)
                .font(.system(size: 10, weight: .bold))
                .padding(10)
                .background(Capsule().fill(Color(hex: category_colors[category] ?? "000000")))
                .padding(.trailing, 10)
                .onTapGesture {
                    selected = "General"
                    post.category = "General"
                }
            
        } else {
            Text(category.uppercased())
                .lineLimit(1)
                .foregroundColor(.white)
                .font(.system(size: 10, weight: .bold))
                .padding(10)
                .background(Capsule().fill(.gray))
                .padding(.trailing, 10)
                .onTapGesture {
                    selected = category
                    post.category = category
                }
            
        }
      
    }
}

struct CategoryIcon_Previews: PreviewProvider {
    static var previews: some View {
        let post: PostModel = PostModel(title: "", userID: "", username: "", description: "", condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [], type: "")
        
        CategoryIcon(post: .constant(post), category: "Bikes", selected: .constant("Bikes"))
    }
}
