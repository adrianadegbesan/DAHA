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
//    @Binding var post : PostModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button(action: {
            if selected != category {
                SoftFeedback()
                selected = category
//                post.category = category
                dismiss()
                
            } else {
                SoftFeedback()
                selected = ""
//                post.category = ""
                dismiss()
            }
        }) {
            ZStack{
                RoundedRectangle(cornerRadius: 23)
                    .fill(Color(hex: category_colors[category] ?? "000000"))
//                    .fill(selected == category ? Color(hex: category_colors[category] ?? "000000") : .gray)
                    .frame(width: screenWidth * 0.44, height: screenHeight * 0.1)
                
                Label(category.uppercased(), systemImage: category_images[category] ?? "")
                    .font(
                        .system(size:20, weight: .bold)
                    )
                    .foregroundColor(.white)
            }
        }
    }
}

struct CategoryIconView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryIconView(category: "Bikes", selected: .constant(""))
    }
}
