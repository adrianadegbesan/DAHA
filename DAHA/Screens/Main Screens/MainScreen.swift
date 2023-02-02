//
//  MainScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

struct MainScreen: View {
    
//    @State var selectedIndex = 0
    @State var shouldNavigate: Bool = false
    
    var body: some View {
        
        TabView{
            HomeScreen()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            SearchScreen()
                .tabItem{
                    Label("Search", systemImage: "magnifyingglass")
                }

            SavedScreen()
                .tabItem{
                    Label("Saved", systemImage: "bookmark")
                }

            ProfileScreen()
                .tabItem{
                    Label("Profile", systemImage: "person.circle")
                }
            
        } //TabView
        .accentColor(Color(hex: "0703d0"))
        .navigationBarBackButtonHidden(true)
        
//
        
    }
}

        
struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            MainScreen()
        }
    }
}
