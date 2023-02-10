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
    
    
    var body: some View {
        Button(action: {
            if selected != type {
                SoftFeedback()
                selected = type
                dismiss()
                
            } else {
                SoftFeedback()
                selected = ""
                dismiss()
            }
        }) {
            ZStack{
                RoundedRectangle(cornerRadius: 23)
                    .fill(.black)
                    .frame(width: screenWidth * 0.6, height: screenHeight * 0.14)
                
                Label(type.uppercased(), systemImage: type_images[type] ?? "")
                    .font(
                        .system(size:30, weight: .bold)
                    )
                    .foregroundColor(.white)
            }
        }

    }
}

struct TypeIcon_Previews: PreviewProvider {
    static var previews: some View {
        
        TypeIcon(selected: .constant(""), type: "Request")
    }
}
