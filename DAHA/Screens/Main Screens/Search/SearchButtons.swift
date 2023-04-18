//
//  SearchButtons.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/15/23.
//

import SwiftUI

struct SearchButtons: View {
    
    var keyboardFocused: FocusState<Bool>.Binding
    @Binding var category : String
    @Binding var type : String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack{
            if category != ""{
                Text(Image(systemName: "multiply.circle.fill"))
                    .font(.system(size: 13, weight: .bold))
                    .background(Circle().fill(.white).scaleEffect(colorScheme == .dark ? 1 : 0.4))
                    .background(Circle().stroke(colorScheme == .dark ? .white : .black, lineWidth: colorScheme == .dark ? 1 : 3))
                    .disabled(keyboardFocused.wrappedValue)
                    .onTapGesture {
                        LightFeedback()
                        withAnimation{
                            hideKeyboard()
                            category = ""
                        }
                    }
                    .foregroundColor(.red)
                
                Label(category.uppercased(), systemImage: category_images[category] ?? "")
                    .lineLimit(1)
                    .foregroundColor(.white)
                    .font(.system(size: 13, weight: .bold))
                    .padding(10)
                    .background(Capsule().fill(Color(hex: category_colors[category] ?? "000000")))
                    .overlay(colorScheme == .dark ? Capsule().stroke(.white, lineWidth: 2) : Capsule().stroke(.black, lineWidth: 3))
                    .padding(.trailing, 10)
                
            } else {
                Text(" ... ")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.clear)
                    .background(Circle().stroke(.clear, lineWidth: 3))
            }
            
                ChooseTypeButton(selected: $type)
                .disabled(keyboardFocused.wrappedValue)
           
        }
        .frame(width: screenWidth, height: 25)
    }
}

//struct SearchButtons_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchButtons()
//    }
//}
