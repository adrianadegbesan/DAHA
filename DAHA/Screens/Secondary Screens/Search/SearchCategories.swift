//
//  SearchCategories.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/10/23.
//

import SwiftUI

struct SearchCategories: View {
    
    @Binding var selected: String
    
    var body: some View {
        VStack{
            HStack{
                SearchCategoryIcon(category: "General", selected: $selected)
                    .padding(.trailing, screenWidth * 0.08)
                SearchCategoryIcon(category: "Clothing", selected: $selected)
            }
            .padding(.bottom, 12)
            HStack{
                SearchCategoryIcon(category: "Tech", selected: $selected)
                    .padding(.trailing, screenWidth * 0.08)
                SearchCategoryIcon(category: "Bikes", selected: $selected)
            }
            .padding(.bottom, 12)
            HStack{
                SearchCategoryIcon(category: "Cars", selected: $selected)
                    .padding(.trailing, screenWidth * 0.08)
                SearchCategoryIcon(category: "Services", selected: $selected)
            }
            .padding(.bottom, 12)
            HStack{
                SearchCategoryIcon(category: "Furniture", selected: $selected)
                    .padding(.trailing, screenWidth * 0.08)
                SearchCategoryIcon(category: "Books", selected: $selected)
            }
            .padding(.bottom, 12)
            HStack{
                SearchCategoryIcon(category: "Outdoor", selected: $selected)
                    .padding(.trailing, screenWidth * 0.08)
                SearchCategoryIcon(category: "Tickets", selected: $selected)
            }
            .padding(.bottom, 12)
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct SearchCategories_Previews: PreviewProvider {
    static var previews: some View {
        SearchCategories(selected: .constant(""))
    }
}
