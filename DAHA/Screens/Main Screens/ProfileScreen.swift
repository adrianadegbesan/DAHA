//
//  ProfileScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

// Profile Screen
struct ProfileScreen: View {
    
    @AppStorage("username") var username_system: String = ""
    var body: some View {
        ZStack {
//            BackgroundColor(color: greyBackground)
            VStack(spacing: 0){
                HeaderView(title: "@\(username_system)", showMessages: false, showSettings: true, showSearchBar: false)
                .frame(alignment: .top)
                Spacer()
                PageBottomDivider()
            } //: VStack
            
            VStack{
                PostButton()
                .offset(x: screenWidth * 0.35, y: screenHeight * 0.325)
            }
        } //: ZStack
//        .background(.gray)

    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
