//
//  HeaderView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI
import SlidingTabView

// Header View utilised throughout this app
struct HeaderView: View {
    
    let title: String
    let showMessages: Bool
    let showSettings: Bool
    let showSearchBar: Bool
    let slidingBar : Bool
    var tabIndex : Binding<Int>?
    var tabs : [String]?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
                // Left half of black block (DAHA logo)
                Image("Logo")
                    .scaleEffect(0.6)
                    .overlay(Rectangle().stroke(colorScheme == .dark ? .white : .clear, lineWidth: 2).scaleEffect(0.6))
                ZStack {
                    // Right half of black block (Page title)
                    Rectangle()
                        // Specific dimensions of rounded rectangle
                        .frame(width: 170, height: colorScheme == .dark ? 66.4 : 65.5)
                        .cornerRadius(18, corners: [.topRight, .bottomRight])
                        .foregroundColor(.black)
                        .background((Rectangle().cornerRadius(18, corners: [.topRight, .bottomRight]).foregroundColor(colorScheme == .dark ? .white : .black).scaleEffect(1.018)))
                      
                        
                        
                    HStack{
                        Text(title)
                            .channelText()
                    }
                }.offset(x: -30)
                // Specific offset to get tounded rectangle attached to DAHA logo
                Spacer()
                
                //If statement that determines which button is shown on the right hand side of the header
                if (showMessages == true){
                    DMButton()
                } else if (showSettings == true){
                    SettingsButton()
                }
                
            } //: HStack
            if slidingBar == true {
                SlidingTabView(selection: tabIndex ?? .constant(0), tabs: tabs ?? [""], font: .headline.weight(.black), activeAccentColor: Color(hex: deepBlue), inactiveAccentColor: colorScheme == .dark ? .white : .black, selectionBarHeight: 5.5, selectionBarBackgroundHeight: 5.5)
//                    .padding(.bottom, 0)
//                    .clipped()
//                    .overlay( RoundedRectangle(cornerRadius: 15).stroke(colorScheme == .dark ? .white : .black, lineWidth: 2).padding(.horizontal, 5) )
                    
            } else if !showSearchBar {
                Divider()
                    .frame(height: 0.5)
                    .overlay(colorScheme == .dark ? Color(hex: darkGrey) : .black)
            }
        } //: VStack

        
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(title: "Stanford", showMessages: true, showSettings: false, showSearchBar: false, slidingBar: true, tabIndex: .constant(0), tabs: ["LISTINGS", "REQUESTS"])
            .previewLayout(.sizeThatFits)
    }
}
