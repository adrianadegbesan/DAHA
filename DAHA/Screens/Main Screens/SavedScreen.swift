//
//  SavedScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

// Saved Screen
struct SavedScreen: View {
    @EnvironmentObject var firestoreManager : FirestoreManager
    @State var opacity = 0.0
    
    var body: some View {
        if #available(iOS 16, *){
                   VStack {
                       ZStack {
                           VStack(spacing: 0) {
                               
                               
                               HeaderView(title: "Saved", showMessages: false, showSettings: false, showSearchBar: false, slidingBar: false, tabIndex: nil, tabs: nil, screen: "Saved")
               //                    .padding(.trailing, 15)
                               .frame(alignment: .top)
                               PostScrollView(posts: $firestoreManager.saved_posts, loading: $firestoreManager.saved_loading, screen: "Saved", query: .constant(""), type: .constant(""), category: .constant(""))
                           } //: VStack
                           .frame(width: screenWidth)
                           
                           VStack{
                               PostButton()
                               .offset(x: screenWidth * 0.35, y: screenHeight * 0.31)
                           }
                           
                       }
                   } //: ZStack
                   
               } else {
                   VStack {
                       ZStack {
                           VStack(spacing: 0) {
                               
                               
                               HeaderView(title: "Saved", showMessages: false, showSettings: false, showSearchBar: false, slidingBar: false, tabIndex: nil, tabs: nil, screen: "Saved")
               //                    .padding(.trailing, 15)
                               .frame(alignment: .top)
                               PostScrollView(posts: $firestoreManager.saved_posts, loading: $firestoreManager.saved_loading, screen: "Saved", query: .constant(""), type: .constant(""), category: .constant(""))
                           } //: VStack
                           .frame(width: screenWidth)
                           
                           VStack{
                               PostButton()
                               .offset(x: screenWidth * 0.35, y: screenHeight * 0.31)
                           }
                           
                       }
                   } //: ZStack
                   .opacity(opacity)
                   .onAppear{
                           withAnimation(.easeIn(duration: 0.4)){
                               opacity = 1.0
                           }
                   }
               }
             
    }
}

struct SavedScreen_Previews: PreviewProvider {
    static var previews: some View {
        SavedScreen()
            .environmentObject(FirestoreManager())
    }
}
