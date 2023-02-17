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
    @Environment(\.colorScheme) var colorScheme
    @State var opacity1 = 1.0
    @State var opacity2 = 0.0
    @State var first = true
    @State var second = false
    

    var body: some View {
        ZStack {
            VStack(spacing: 0){
                HeaderView(title: "@\(username_system)", showMessages: false, showSettings: true, showSearchBar: false, slidingBar: true, tabIndex: $tabIndex, tabs: tabs, screen: "Profile")
                .frame(alignment: .top)
                
                
                HStack {
                    Spacer()
                    VStack {
                       (Text(Image(systemName: "person.circle")) + Text(" MY POSTS"))
                            .font(.headline.weight(.black))
                            .foregroundColor(first ? Color(hex: deepBlue) : .primary)
                        Divider()
                            .frame(width: screenWidth * 0.35, height: 3.5)
                            .overlay(Color(hex: deepBlue))
                            .opacity(opacity1)
                            
                    }
                    .onTapGesture {
                        tabIndex = 0
                    }
                   
                    Spacer()
                    VStack {
                        (Text(Image(systemName: "bookmark.fill")) +  Text(" SAVED"))
                            .font(.headline.weight(.black))
                        .foregroundColor(second ? Color(hex: deepBlue) : .primary)
                        Divider()
                            .frame(width: screenWidth * 0.35, height: 3.5)
                            .overlay(Color(hex: deepBlue))
                            .opacity(opacity2)
                    }
                    .onTapGesture {
                        tabIndex = 1
                    }
                    Spacer()
                }
                .background(colorScheme == .dark ? .clear : Color(hex: greyBackground))
                
                TabView(selection: $tabIndex){
                    UserPostsView().tag(0)
                    SavedPostsView().tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                
//                if tabIndex == 0{
//                    PostScrollView(posts: $firestoreManager.my_posts, loading: $firestoreManager.my_posts_loading, screen: "User", query: .constant(""), type: .constant(""), category: .constant(""))
//                } else if tabIndex == 1 {
//                    PostScrollView(posts: $firestoreManager.saved_posts, loading: $firestoreManager.saved_loading, screen: "Saved", query: .constant(""), type: .constant(""), category: .constant(""))
//                }
//                PageBottomDivider()
            } //: VStack
            .onChange(of: tabIndex){ value in
                if tabIndex == 0 {
                    withAnimation {
                        first = true
                        second = false
                        opacity1 = 1
                        opacity2 = 0
                    }
                } else {
                    withAnimation {
                        first = false
                        second = true
                        opacity1 = 0
                        opacity2 = 1
                    }
                }
            }

            
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
