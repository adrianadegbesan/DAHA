//
//  HeaderView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

// Header View utilised throughout this app
struct HeaderView: View {
    
    let title: String
    let showMessages: Bool
    let showSettings: Bool
    let showSearchBar: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack{
                // Left half of black block (DAHA logo)
                Image("Logo")
                    .scaleEffect(0.6)
                ZStack {
                    // Right half of black block (Page title)
                    RoundedRectangle(cornerRadius: 12)
                        // Specific dimensions of rounded rectangle
                        .frame(width: 170, height: 67)
                        .foregroundColor(.black)
                        
                    HStack{
                        Text(title)
                            .channelText()
                    }
                }.offset(x: -38.2)
                // Specific offset to get tounded rectangle attached to DAHA logo
                Spacer()
                
                //If statement that determines which button is shown on the right hand side of the header
                if (showMessages == true){
                    DMButton()
                } else if (showSettings == true){
                    SettingsButton()
                }
                
            } //: HStack
            Divider()
                .frame(height: 0.5)
                .overlay(Color(hex: "000000"))
        } //: ZStack
        .background(.gray.opacity(0.09))
        
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(title: "Stanford", showMessages: true, showSettings: false, showSearchBar: false)
            .previewLayout(.sizeThatFits)
    }
}
