//
//  HomeScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI
import Firebase
import SlidingTabView

// Home Screen
struct HomeScreen: View {
    @AppStorage("university") var university: String = ""
    @State var shouldNavigate : Bool = false
    @State private var tabIndex : Int = 0
    @State private var tabs : [String] = ["LISTINGS", "REQUESTS"]
    @EnvironmentObject var firestoreManager : FirestoreManager

    
    var body: some View {
            ZStack {
                VStack(spacing: 0) {
                    HeaderView(title: university, showMessages: true, showSettings: false, showSearchBar: true, slidingBar: true, tabIndex: $tabIndex, tabs: tabs, screen: "Home")
                        .frame(alignment: .top)
//                    Spacer()
                    if tabIndex == 0{
                        PostScrollView(posts: $firestoreManager.listings, loading: $firestoreManager.listings_loading, screen: "Listings", query: .constant(""), type: .constant(""), category: .constant(""))
                    } else if tabIndex == 1 {
                        PostScrollView(posts: $firestoreManager.requests, loading: $firestoreManager.requests_loading, screen: "Requests", query: .constant(""), type: .constant(""), category: .constant(""))
                    }
                     
//                    Spacer()
//    
                    
//                    PageBottomDivider()
                } //: VStack
//
                VStack{
                    PostButton()
                    .offset(x: screenWidth * 0.35, y: screenHeight * 0.325)
                }
                
                NavigationLink(destination: MakePostScreen(), isActive: $shouldNavigate){
                    EmptyView()
                }
                
            } //: ZStack
            .keyboardControl()
            .navigationBarBackButtonHidden(true)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
            HomeScreen()
    }
}
