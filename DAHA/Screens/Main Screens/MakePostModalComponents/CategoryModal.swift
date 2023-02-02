//
//  CategoryModal.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/1/23.
//

import SwiftUI

struct CategoryModal: View {
    
    @Binding var post: PostModel
    @Binding var selected: String
    
    
    let categories: [String] = ["General", "Clothing", "Tech", "Bikes", "Cars", "Art", "Furniture", "Books", "Games", "Tickets"]
    
    var body: some View {
        ZStack {
//            BackgroundColor(color: greyBackground)
            
            VStack{
                Capsule()
                    .frame(width: 40, height: 8)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
                Spacer()
                Text("Categories")
                    .font(
                        .system(size:30, weight: .heavy)
                    )
                Spacer()
                HStack{
                    CategoryIconView(category: "General", selected: $selected, post: $post)
                    CategoryIconView(category: "Clothing", selected: $selected, post: $post)
                }
                .padding(.bottom, 25)
                HStack{
                    CategoryIconView(category: "Tech", selected: $selected, post: $post)
                    CategoryIconView(category: "Bikes", selected: $selected, post: $post)
                }
                .padding(.bottom, 25)
                HStack{
                    CategoryIconView(category: "Cars", selected: $selected, post: $post)
                    CategoryIconView(category: "Art", selected: $selected, post: $post)
                }
                .padding(.bottom, 25)
                HStack{
                    CategoryIconView(category: "Furniture", selected: $selected, post: $post)
                    CategoryIconView(category: "Books", selected: $selected, post: $post)
                }
                .padding(.bottom, 25)
                HStack{
                    CategoryIconView(category: "Games", selected: $selected, post: $post)
                    CategoryIconView(category: "Tickets", selected: $selected, post: $post)
                }
                .background(.ultraThinMaterial)
                .padding(.bottom, 25)
            }
        }
    }
}

struct CategoryModal_Previews: PreviewProvider {
    static var previews: some View {
        let post: PostModel = PostModel(title: "", userID: "", username: "", description: "", condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [])
        CategoryModal(post: .constant(post), selected: .constant(""))
    }
}
