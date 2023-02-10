//
//  SearchCategoryIcon.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/10/23.
//

import SwiftUI

struct SearchCategoryIcon: View {
    
    @State var category : String
    @Binding var selected : String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: {
            hideKeyboard()
            if selected != category {
                SoftFeedback()
                selected = category
                
            } else {
                SoftFeedback()
                selected = ""
            }
        }) {
            ZStack{
                RoundedRectangle(cornerRadius: 23)
                    .fill(Color(hex: category_colors[category] ?? "000000"))
                    .frame(width: screenWidth * 0.34, height: screenHeight * 0.075)
                
                Label(category.uppercased(), systemImage: category_images[category] ?? "")
                    .font(
                        .system(size:15, weight: .bold)
                    )
                    .foregroundColor(.white)
            }
            .background(RoundedRectangle(cornerRadius: 23).stroke(colorScheme == .dark ? .white : .black, lineWidth: colorScheme == .dark ? 2 : 4))
        }
    }
}

struct SearchCategoryIcon_Previews: PreviewProvider {
    static var previews: some View {
        SearchCategoryIcon(category: "General", selected: .constant(""))
    }
}
