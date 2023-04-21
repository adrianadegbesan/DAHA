//
//  CategoryModal.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/1/23.
//

import SwiftUI

struct CategoryModal: View {
    
//    @Binding var post: PostModel
    @Binding var selected: String
    @State var modal : Bool
    @Environment(\.dismiss) private var dismiss
    
    let categories: [String] = ["General", "Clothing", "Tech", "Bikes", "Rides", "Art", "Furniture", "Books", "Games", "Tickets"]
    
    var body: some View {
        ZStack {
//            BackgroundColor(color: greyBackground)
            
            VStack{
                
                if modal {
                    HStack{
                        Image(systemName: "multiply")
                            .font(.system(size: 25, weight: .heavy))
                            .onTapGesture {
                                dismiss()
                            }
                            .padding(.leading, 15)
                            .padding(.top, 5)
                        Spacer().frame(width: screenWidth * 0.37)
                        ModalCapsule()
                        Spacer()
                    }
                  
                        .padding(.top, 10)
                    Spacer()
                    Text("Categories")
                        .font(
                            .system(size:30, weight: .heavy)
                        )
                    Spacer()
                }
                HStack{
                    CategoryIconView(category: "General", selected: $selected)
                        .padding(.trailing, 10)
                    CategoryIconView(category: "Clothing", selected: $selected)
                }
                .padding(.bottom, 25)
                HStack{
                    CategoryIconView(category: "Tech", selected: $selected)
                        .padding(.trailing, 10)
                    CategoryIconView(category: "Bikes", selected: $selected)
                }
                .padding(.bottom, 25)
                HStack{
                    CategoryIconView(category: "Rides", selected: $selected)
                        .padding(.trailing, 10)
                    CategoryIconView(category: "Services", selected: $selected)
                }
                .padding(.bottom, 25)
                HStack{
                    CategoryIconView(category: "Furniture", selected: $selected)
                        .padding(.trailing, 10)
                    CategoryIconView(category: "Books", selected: $selected)
                }
                .padding(.bottom, 25)
                HStack{
                    CategoryIconView(category: "Outdoor", selected: $selected)
                        .padding(.trailing, 10)
                    CategoryIconView(category: "Tickets", selected: $selected)
                }
                .padding(.bottom, 25)
                Spacer()
            }
        }
    }
}

struct CategoryModal_Previews: PreviewProvider {
    static var previews: some View {
        CategoryModal(selected: .constant(""), modal: false)
    }
}
