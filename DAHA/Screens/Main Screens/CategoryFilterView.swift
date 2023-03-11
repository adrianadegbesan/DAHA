//
//  CategoryFilterView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/11/23.
//

import SwiftUI

struct CategoryFilterView: View {
    
    var categories : [String] = ["General", "Clothing", "Tech", "Bikes",
                                 "Cars", "Services", "Furniture", "Books", "Outdoor", "Tickets"]
    @Binding var selected : String 
    @State var screen : String
    @Binding var posts: [PostModel]
    @Binding var loading: Bool
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                ForEach(categories, id: \.self){ category in
                    CategoryFilterIcon(category: category, selected: $selected, screen: screen, posts: $posts, loading: $loading)
                        .padding(10)
                }
            }
        }
    }
}

struct CategoryFilterView_Previews: PreviewProvider {
    static var previews: some View {
        
        let screen = "Listings"
        let posts : [PostModel] = []
        CategoryFilterView(selected: .constant("General"), screen: screen, posts: .constant(posts), loading: .constant(false))
    }
}
