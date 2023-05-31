//
//  TypeIcon.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/9/23.
//

import SwiftUI

struct TypeIcon: View {
    
//    @Binding var post: PostModel
    @Binding var selected : String
    @State var type : String
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        Button(action: {
            if selected != type {
                SoftFeedback()
                withAnimation{
                    selected = type
                }
                dismiss()
                
            } else {
                SoftFeedback()
                withAnimation{
                    selected = ""
                }
                dismiss()
            }
        }) {
            ZStack{
                RoundedRectangle(cornerRadius: 23)
                    .fill(.black)
                    .frame(width: screenWidth * 0.55, height: screenHeight * 0.12)
                    .overlay(RoundedRectangle(cornerRadius: 23).stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
                
                Label(type.uppercased(), systemImage: type_images[type] ?? "")
                    .font(
                        .system(size:27, weight: .bold)
                    )
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(.plain)

    }
}

struct TypeIcon_Previews: PreviewProvider {
    static var previews: some View {
        
        TypeIcon(selected: .constant(""), type: "Request")
    }
}
