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
    @Environment(\.colorScheme) var colorScheme
    @State var opacity1 = 1.0
    @State var opacity2 = 0.0
    @State var first = true
    @State var second = false

    
    var body: some View {
            ZStack {
                VStack(spacing: 0) {
                    HeaderView(title: university, showMessages: true, showSettings: false, showSearchBar: true, slidingBar: true, tabIndex: $tabIndex, tabs: tabs, screen: "Home")
                        .frame(alignment: .top)
                    
                    HStack {
                        Spacer()
                        VStack {
                           (Text(Image(systemName: "cart.circle")) + Text(" LISTINGS"))
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
                            (Text(Image(systemName: "figure.stand.line.dotted.figure.stand")) +  Text(" REQUESTS"))
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
                        ListingsView().tag(0)
                        RequestsView().tag(1)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
 
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
