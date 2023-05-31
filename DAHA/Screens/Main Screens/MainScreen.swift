//
//  MainScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

struct MainScreen: View {
    
//    @State var selectedIndex = 0
    @State private var shouldNavigate: Bool = false
    @State private var tabSelection: Int = 0
    @State private var current: Int = 0
    @EnvironmentObject var firestoreManager : FirestoreManager
    @EnvironmentObject var authManager : AuthManager
    @EnvironmentObject var messageManager : MessageManager
    @EnvironmentObject var appState : AppState
    
    
    var body: some View {
        
        /*Main Screen tab view*/
        TabView(selection: $tabSelection.onUpdate {
            setNewValue(value: tabSelection)
        }){
            HomeScreen()
                .hideNavigationBar(value: $appState.isNavigationBarHidden)
                .tabItem {
                    Label("", systemImage: "house")
                    .onTapGesture {
                        firestoreManager.scroll_up = true
                    }
                }
                .tag(0)
               

            SearchScreen()
                .hideNavigationBar(value: $appState.isNavigationBarHidden)
                .tabItem{
                    Label("", systemImage: "magnifyingglass")
                }
                .tag(1)
            
            SavedScreen()
                .hideNavigationBar(value: $appState.isNavigationBarHidden)
                .tabItem{
                    Label("", systemImage: "bookmark")
                }
                .tag(2)

            ProfileScreen()
                .hideNavigationBar(value: $appState.isNavigationBarHidden)
                .tabItem{
                    Label("", systemImage: "person.circle")
                }
                .tag(3)
               
        } //TabView
        .onAppear{
//            hideKeyboard()
            if appState.firstSignOn{
                Task {
                    await firestoreManager.getListings()
                    await firestoreManager.getRequests()
                    let _ = messageManager.getMessageChannels()
                    appState.firstSignOn = false
                }
            }
            /*Change tab view indicator colour*/
            let appearance: UITabBarAppearance = UITabBarAppearance()
            UITabBar.appearance().scrollEdgeAppearance = appearance
            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color(hex: deepBlue))
            UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color(hex: "D1D0CE"))
        }
        .animation(.easeIn(duration: 0.5), value: tabSelection)
        .accentColor(Color(hex: "0000FF"))
        .navigationBarTitle("")
        .navigationBarTitleDisplayMode(.inline)
//
    
    }
    
    func setNewValue(value: Int){
        self.tabSelection = value
        if self.tabSelection == 0 && self.current == 0{
            firestoreManager.scroll_up = true
        }
        self.current = value
     }
}

        
struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            MainScreen()
        }
    }
}
