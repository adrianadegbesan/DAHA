//
//  SavedScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

// Saved Screen
struct SavedScreen: View {
    var body: some View {
        VStack {
            ZStack {
                VStack(spacing: 0) {
                    HeaderView(title: "Saved", showMessages: false, showSettings: false, showSearchBar: false, slidingBar: false, tabIndex: nil, tabs: nil, screen: "Saved")
                        .frame(alignment: .top)
                    TabView(){
                        SavedView()
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    Divider()
                } //: VStack
                .frame(width: screenWidth)
                
                VStack{
                    PostButton()
                        .offset(x: screenWidth * 0.35, y: screenHeight * 0.31)
                }
            }
            
        } //: ZStack
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden(true)
    }
}

struct SavedScreen_Previews: PreviewProvider {
    static var previews: some View {
        SavedScreen()
            .environmentObject(FirestoreManager())
    }
}
