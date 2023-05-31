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
    @Environment(\.colorScheme) var colorScheme
    
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
                    .frame(width: screenWidth * 0.44, height: screenHeight * 0.1)
                    .overlay(RoundedRectangle(cornerRadius: 23).stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
                
                Label(category.uppercased(), systemImage: category_images[category] ?? "")
                    .font(
                        .system(size:20, weight: .bold)
                    )
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(.plain)
    }
}

struct CategoryIconView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryIconView(category: "General", selected: .constant(""))
    }
}
