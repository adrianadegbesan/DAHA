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
               ModalCapsule()
                    .padding(.top, 10)
                Spacer()
                Text("Categories")
                    .font(
                        .system(size:30, weight: .heavy)
                    )
                Spacer()
                HStack{
                    CategoryIconView(category: "General", selected: $selected, post: $post)
                        .padding(.trailing, 10)
                    CategoryIconView(category: "Clothing", selected: $selected, post: $post)
                }
                .padding(.bottom, 25)
                HStack{
                    CategoryIconView(category: "Tech", selected: $selected, post: $post)
                        .padding(.trailing, 10)
                    CategoryIconView(category: "Bikes", selected: $selected, post: $post)
                }
                .padding(.bottom, 25)
                HStack{
                    CategoryIconView(category: "Cars", selected: $selected, post: $post)
                        .padding(.trailing, 10)
                    CategoryIconView(category: "Art", selected: $selected, post: $post)
                }
                .padding(.bottom, 25)
                HStack{
                    CategoryIconView(category: "Furniture", selected: $selected, post: $post)
                        .padding(.trailing, 10)
                    CategoryIconView(category: "Books", selected: $selected, post: $post)
                }
                .padding(.bottom, 25)
                HStack{
                    CategoryIconView(category: "Games", selected: $selected, post: $post)
                        .padding(.trailing, 10)
                    CategoryIconView(category: "Tickets", selected: $selected, post: $post)
                }
                .padding(.bottom, 25)
                Spacer()
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