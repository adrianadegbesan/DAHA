//
//  CategorySelectorView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/31/23.
//

import SwiftUI

struct CategorySelectorView: View {
    
    @Binding var post: PostModel
    
    let categories: [String] = ["General", "Clothing", "Tech", "Bikes", "Cars", "Art", "Furniture", "Books", "Games", "Tickets"]
    
    @State private var selected: String = "General"
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                ForEach(categories, id: \.self){ category in
                    CategoryIcon(post: $post, category: category, selected: $selected)
                }
                .padding(.horizontal, 0)
            }
        }
    }
}

struct CategorySelectorView_Previews: PreviewProvider {
    static var previews: some View {
        let post: PostModel = PostModel(title: "", userID: "", username: "", description: "", condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [])
        
        CategorySelectorView(post: .constant(post))
    }
}
