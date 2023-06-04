//
//  CategoryFilterView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/11/23.
//

import SwiftUI

struct CategoryFilterView: View {
    
    var categories : [String] = ["General", "Clothing", "Tech", "Bikes",
                                 "Rides", "Services", "Furniture", "Books", "Outdoor", "Tickets"]
    @Binding var selected : String 
    @State var screen : String
    @Binding var posts: [PostModel]
    @Binding var loading: Bool
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                Spacer().frame(width: 5)
                ForEach(categories, id: \.self){ category in
                    CategoryFilterIcon(category: category, selected: $selected, screen: screen, posts: $posts, loading: $loading)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 8)
                }
                Spacer().frame(width: 5)
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
