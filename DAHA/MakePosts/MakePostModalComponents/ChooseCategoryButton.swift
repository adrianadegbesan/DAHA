//
//  ChooseCategoryButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/1/23.
//

import SwiftUI

struct ChooseCategoryButton: View {
    @State private var categoryPresented: Bool = false
    @Binding var selected: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            Button(action: {
                LightFeedback()
                if selected == "" {
                    hideKeyboard()
                    categoryPresented = true
                } else {
                    withAnimation{
                        selected = ""
                    }
                }
            }) {
                if (selected == ""){
                    Text("Choose Category")
                            .lineLimit(1)
                            .font(.system(size: 13, weight: .bold))
                            .padding(10)
                            .background(Capsule().stroke(lineWidth: 5))
                            .padding(.trailing, 10)
                            .foregroundColor(.blue)
                } else {
                    Text(Image(systemName: "multiply.circle.fill"))
                        .font(.system(size: 13, weight: .bold))
                        .background(Circle().fill(.white).scaleEffect(colorScheme == .dark ? 1 : 0.4))
                        .background(Circle().stroke(colorScheme == .dark ? .white : .black, lineWidth: colorScheme == .dark ? 1 : 3))
                        .foregroundColor(.red)
                }
            
            }
            .buttonStyle(.plain)
            
            if (selected != ""){
                Label(selected.uppercased(), systemImage: category_images[selected] ?? "")
                    .lineLimit(1)
                    .foregroundColor(.white)
                    .font(.system(size: 13, weight: .bold))
                    .padding(10)
                    .background(Capsule().fill(Color(hex: category_colors[selected] ?? "000000")))
                    .overlay(colorScheme == .dark ? Capsule().stroke(.white, lineWidth: 2) : Capsule().stroke(.black, lineWidth: 3))
                    .padding(.trailing, 10)
            }
            
        }
        .sheet(isPresented: $categoryPresented){
                CategoryModal(selected: $selected, modal: true)
        }
    }
}


struct ChooseCategoryButton_Previews: PreviewProvider {
    static var previews: some View {
        ChooseCategoryButton(selected: .constant(""))
    }
}
