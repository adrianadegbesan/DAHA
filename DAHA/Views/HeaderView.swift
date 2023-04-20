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
    @State var isAnimating: Bool = false
    
    @FocusState private var keyboardFocused: Bool
    @State var query = ""
    @State var category = ""
    @State var type = ""
    @State var shouldNavigate = false
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var network : Network
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
          
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
                                .font(.system(size: screen == "User" ? 17 : 18.5, weight: .bold))
                                .scaleEffect(screen == "User" && title.count >= 10 ? 0.95 : 1)
                                .foregroundColor(.white)
                                
                        }
                    }
                    .offset(x: -30)
                }
                .scaleEffect(isAnimating ? 1.075 : 1.0)
                .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1), value: isAnimating)
                .onTapGesture{
                    if !isAnimating{
                        SoftFeedback()
                        isAnimating = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                           isAnimating = false
                        }
                    }
                 }
 
                
                Spacer()

                if showMessages {
                    
                    if network.connected == false {
                        Image(systemName: "wifi.slash")
                            .headerImage()
                            .foregroundColor(.red)
                            .transition(.opacity)
                    }
//                    SearchButton()
//                        .padding(.trailing, 3)
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
            
            if screen == "Home"{
                TextField("Does Anyone Have A...?", text: $query)
                    .textFieldStyle(OvalTextFieldStyle(icon: Image(systemName: "magnifyingglass")))
                    .background(colorScheme == .dark ? Color(hex: dark_scroll_background).cornerRadius(20) : Color(hex: light_scroll_background).cornerRadius(20))
                    .submitLabel(.search)
                    .onSubmit {
                        if !(query.trimmingCharacters(in: .whitespacesAndNewlines) == "" && category == "" && type == ""){
                            shouldNavigate = true
                        }
                    }
                    .focused($keyboardFocused)
                    .background(Color.primary.opacity(0.05))
                    .padding(.horizontal, screenWidth * 0.06)
                    .padding(.bottom, 25)
                
                NavigationLink(destination: SearchBarScreen(query: $query, category: $category, type: $type), isActive: $shouldNavigate){
                    EmptyView()
                }
               
            }
        } //: VStack
//        .background(colorScheme == .dark || screen == "Search" ? .clear : Color(hex: greyBackground))
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(title: "Stanford", showMessages: true, showSettings: false, showSearchBar: false, slidingBar: true, tabIndex: .constant(0), tabs: ["LISTINGS", "REQUESTS"], screen: "Home")
            .previewLayout(.sizeThatFits)
    }
}
