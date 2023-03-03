//
//  MessageOptions.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/3/23.
//

import SwiftUI

struct MessageOptions: View {
    var body: some View {
        Menu{
           
           
            
            Button(role: .destructive){
                
            } label:{
                Label("Report User", systemImage: "flag")
            }
            
            Button(role: .destructive){
                
            } label:{
                Label("Delete Chat", systemImage: "trash")
            }
            
        } label: {
            Label("", systemImage: "ellipsis.circle")
        }
        .foregroundColor(.primary)
    }
}

struct MessageOptions_Previews: PreviewProvider {
    static var previews: some View {
        MessageOptions()
    }
}
