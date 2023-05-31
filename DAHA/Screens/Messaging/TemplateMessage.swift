//
//  TemplateMessage.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 5/9/23.
//

import SwiftUI

struct TemplateMessage: View {
    @State var text: String
    @Binding var message : String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: {
            message = text
        }){
            Text(text)
                .font(.system(size: 15, weight: .semibold))
                .padding(13)
                .overlay(Capsule().stroke(lineWidth: 1.5))
//                .padding(.bottom, 5)
               
        }
        .buttonStyle(.plain)
        .foregroundColor(.primary)
        
        
            
    }
}

struct TemplateMessage_Previews: PreviewProvider {
    static var previews: some View {
        TemplateMessage(text: "I'm willing to buy this for", message: .constant(""))
    }
}
