//
//  MainScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

struct MainScreen: View {
    
    @State var selectedIndex = 0

    
    var body: some View {
        
        TabView{
            HomeScreen()
                .tabItem {
                    Label("", systemImage: "house")
                }

            SearchScreen()
                .tabItem{
                    Label("", systemImage: "magnifyingglass")
                }

            SavedScreen()
                .tabItem{
                    Label("", systemImage: "bookmark")
                }

            ProfileScreen()
                .tabItem{
                    Label("", systemImage: "person.circle")
                }
        } //TabView
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
