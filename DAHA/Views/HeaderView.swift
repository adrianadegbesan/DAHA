//
//  HeaderView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI
//import SlidingTabView

// Header View utilised throughout this app
struct HeaderView: View {
    
    let title: String
    let showMessages: Bool
    let showSettings: Bool
    let showSearchBar: Bool
    let slidingBar : Bool
    var tabIndex : Binding<Int>?
    var tabs : [String]?
    var screen: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
          
                Image("Logo")
                    .scaleEffect(0.6)
                    .overlay(Rectangle().stroke(colorScheme == .dark ? .white : .clear, lineWidth: 2).scaleEffect(0.6))
                ZStack {
                    
                    Rectangle()
                        // Specific dimensions of rounded rectangle
                        .frame(width: 170, height: colorScheme == .dark ? 66.4 : 65.5)
                        .cornerRadius(18, corners: [.topRight, .bottomRight])
                        .foregroundColor(.black)
                        .background((Rectangle().cornerRadius(18, corners: [.topRight, .bottomRight]).foregroundColor(colorScheme == .dark ? .white : .black).scaleEffect(1.018)))
                      
                        
                        
                    HStack{
                        Text(title)
                            .lineLimit(1)
                            .minimumScaleFactor(0.01)
                            .font(.system(size: screen == "User" ? 17 : 19, weight: .bold))
                            .foregroundColor(.white)
                            
                    }
                }.offset(x: -30)
 
                
                Spacer()

                if showMessages {
                    DMButton()
                } else if showSettings {
                    SettingsButton()
                }
                
            } //: HStack
                
            if screen == "Saved" {
                Divider()
                    .frame(height: 0.5)
                    .overlay(colorScheme == .dark ? Color(hex: darkGrey) : .black)
            }
        } //: VStack
        .background(colorScheme == .dark || screen == "Search" ? .clear : Color(hex: greyBackground))
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(title: "Stanford", showMessages: true, showSettings: false, showSearchBar: false, slidingBar: true, tabIndex: .constant(0), tabs: ["LISTINGS", "REQUESTS"], screen: "Home")
            .previewLayout(.sizeThatFits)
    }
}
