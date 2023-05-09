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
    
    var body: some View {
        Button(action: {
            message = text
        }){
            Text(text)
                .font(.system(size: 15))
                .padding(12)
                .overlay(Capsule().stroke(lineWidth: 1).foregroundColor(.secondary))
                .padding(.bottom, 5)
        }
        .foregroundColor(.primary)
        
            
    }
}

struct TemplateMessage_Previews: PreviewProvider {
    static var previews: some View {
        TemplateMessage(text: "I'm willing to buy this for", message: .constant(""))
    }
}
