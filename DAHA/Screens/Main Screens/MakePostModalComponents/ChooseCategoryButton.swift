//
//  ChooseCategoryButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/1/23.
//

import SwiftUI

struct ChooseCategoryButton: View {
    @State var isPresented: Bool = false
    @State var selected: String = ""
    @Binding var post: PostModel
    
    var body: some View {
        HStack {
            Text("Choose Category")
                    .lineLimit(1)
                    .font(.system(size: 15, weight: .bold))
                    .padding(10)
                    .background(Capsule().stroke(lineWidth: 5))
                    .padding(.trailing, 10)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        isPresented = true
                    }
            
            if (selected != ""){
                Label(post.category.uppercased(), systemImage: category_images[post.category] ?? "")
                    .lineLimit(1)
                    .foregroundColor(.white)
                    .font(.system(size: 15, weight: .bold))
                    .padding(10)
                    .background(Capsule().fill(Color(hex: category_colors[selected] ?? "000000")))
                    .padding(.trailing, 10)
            }
            
        }
        .sheet(isPresented: $isPresented){
                CategoryModal(post: $post, selected: $selected)
        }
    }
}


struct ChooseCategoryButton_Previews: PreviewProvider {
    static var previews: some View {
        let post: PostModel = PostModel(title: "", userID: "", username: "", description: "", condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [])
        ChooseCategoryButton(post: .constant(post))
    }
}
