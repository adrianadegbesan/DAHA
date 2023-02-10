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
    @State private var tabIndex : Int = 0
    @State private var tabs : [String] = ["MY POSTS", "SAVED"]

    var body: some View {
        ZStack {
            VStack(spacing: 0){
                HeaderView(title: "@\(username_system)", showMessages: false, showSettings: true, showSearchBar: false, slidingBar: true, tabIndex: $tabIndex, tabs: tabs)
                .frame(alignment: .top)
                if tabIndex == 0{
                    ScrollView{
//                            PostView(post: post, owner: false)
//                                .padding(.top, 10)
                    }
                    .refreshable {

                    }
                } else if tabIndex == 1 {
                    ScrollView{
//                            PostView(post: post, owner: false)
//                                .padding(.top, 10)
                    }
                    .refreshable {

                    }
                }
                Spacer()
                PageBottomDivider()
            } //: VStack
            
            VStack{
                PostButton()
                .offset(x: screenWidth * 0.35, y: screenHeight * 0.325)
            }
        } //: ZStack

    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
