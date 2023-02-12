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
    @EnvironmentObject var firestoreManager : FirestoreManager

    var body: some View {
        ZStack {
            VStack(spacing: 0){
                HeaderView(title: "@\(username_system)", showMessages: false, showSettings: true, showSearchBar: false, slidingBar: true, tabIndex: $tabIndex, tabs: tabs)
                .frame(alignment: .top)
                if tabIndex == 0{
                    PostScrollView(posts: $firestoreManager.my_posts, loading: $firestoreManager.my_posts_loading, screen: "User", query: .constant(""), type: .constant(""), category: .constant(""))
                } else if tabIndex == 1 {
                    PostScrollView(posts: $firestoreManager.saved_posts, loading: $firestoreManager.saved_loading, screen: "Saved", query: .constant(""), type: .constant(""), category: .constant(""))
                }
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
