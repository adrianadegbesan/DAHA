//
//  PostViewModifiers.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 5/19/23.
//

import SwiftUI


struct PostViewModifier: ViewModifier {
    @State var post: PostModel
    @Binding var price: String
    @Binding var reported: Bool
    @State private var Sold: Bool = false
    @Environment(\.colorScheme) var colorScheme
                  
    func body(content: Content) -> some View {
        content
            .frame(width: screenWidth * 0.902, height: 170)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(Sold ? Color(hex: color_new) : (reported ? .red : (colorScheme == .dark ? .gray : .gray)), lineWidth: colorScheme == .dark ? 2 : 2)
            )
            .background(colorScheme == .dark ? Color.black.opacity(0.7): Color.white)
            .cornerRadius(20)
            .onAppear{
                if (post.price == "Sold" || post.price == "Satisfied") {
                    Sold = true
                }
            }
            .onChange(of: post.price){ value in
                if (post.price == "Sold" || post.price == "Satisfied"){
                    Sold = true
                }
            }
            .onChange(of: price){ value in
                if (price == "Sold" || price == "Satisfied"){
                    Sold = true
                }
            }
        
    }
}
