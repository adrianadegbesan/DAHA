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
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                
                
                HeaderView(title: "Saved", showMessages: false, showSettings: false, showSearchBar: false, slidingBar: false, tabIndex: nil, tabs: nil, screen: "Saved")
                .frame(alignment: .top)
                PostScrollView(posts: $firestoreManager.saved_posts, loading: $firestoreManager.saved_loading, screen: "Saved", query: .constant(""), type: .constant(""), category: .constant(""))
            } //: VStack
            .frame(width: screenWidth)
            
            VStack{
                PostButton()
                .offset(x: screenWidth * 0.35, y: screenHeight * 0.31)
            }
            
        } //: ZStack
    }
}

struct SavedScreen_Previews: PreviewProvider {
    static var previews: some View {
        SavedScreen()
    }
}
