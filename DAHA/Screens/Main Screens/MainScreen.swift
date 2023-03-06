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
    @State var tabSelection: Int = 0
    @EnvironmentObject var firestoreManager : FirestoreManager
    
    
    var body: some View {
        
        /*Main Screen tab view*/
        TabView(selection: $tabSelection){
            HomeScreen()
                .tabItem {
                    Label("", systemImage: "house")
                    .onTapGesture {
                        firestoreManager.scroll_up = true
                    }
                }
                .tag(0)
               


            SearchScreen()
                .tabItem{
                    Label("", systemImage: "magnifyingglass")
                }
                .tag(1)

            SavedScreen()
                .tabItem{
                    Label("", systemImage: "bookmark")
                }
                .tag(2)

            ProfileScreen()
                .tabItem{
                    Label("", systemImage: "person.circle")
                }
                .tag(3)
            
        } //TabView
        .onAppear{
            /*Change tab view indicator colour*/
            let appearance: UITabBarAppearance = UITabBarAppearance()
            UITabBar.appearance().scrollEdgeAppearance = appearance
            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color(hex: deepBlue))
            UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color(hex: "D1D0CE"))
        }
        .animation(.easeIn(duration: 0.5), value: tabSelection)
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
