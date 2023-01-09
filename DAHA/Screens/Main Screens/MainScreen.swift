//
//  MainScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

struct MainScreen: View {
    
    @State var selectedIndex = 0
    @State var hideTabBar: Bool = false
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 0){
                
                ZStack(){
                    
                    // Switch statements for custom tab bar functionality
                    switch selectedIndex {
                    
                    // Home icon
                    case 0:
                        HomeScreen()
                    // Search icon
                    case 1:
                        SearchScreen()
                    // Bookmark icon
                    case 2:
                        SavedScreen()
                    // Profile icon
                    case 3:
                        ProfileScreen()
                        
                    default:
                        Image(systemName: "logo")
                    }
                    
                    VStack{
                        PostButton()
                            .offset(x: screenWidth * 0.33, y: screenWidth * 0.65)
                    }
                    
                } //:ZStack
                
                TabBarView(selectedIndex: $selectedIndex)
                    .frame(alignment: .bottom)
                
            } //: VStack
        } //: Navigation
    }
}

        
struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
