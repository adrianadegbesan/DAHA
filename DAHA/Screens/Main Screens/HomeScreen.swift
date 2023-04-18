//
//  HomeScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI
import Firebase

// Home Screen
struct HomeScreen: View {
    @AppStorage("university") var university: String = ""
    @State var shouldNavigate : Bool = false
    @State private var tabIndex : Int = 0
    @State private var tabs : [String] = ["LISTINGS", "REQUESTS"]
    @EnvironmentObject var firestoreManager : FirestoreManager
    @Environment(\.colorScheme) var colorScheme
    @State private var opacity1 = 1.0
    @State private var opacity2 = 0.0
    @State private var first = true
    @State private var second = false
    @State private var dividerOffset: CGFloat = 0

    
    var body: some View {
            ZStack {
                VStack(spacing: 0) {
                    HeaderView(title: university, showMessages: true, showSettings: false, showSearchBar: true, slidingBar: true, tabIndex: $tabIndex, tabs: tabs, screen: "Home")
                        .frame(alignment: .top)
                    
                    /*Tab View Section Headers with animation*/
                    HStack {
                        Spacer()
                        VStack(spacing: 10){
                           (Text(Image(systemName: "cart.circle")) + Text(" LISTINGS"))
                                .font(.headline.weight(.black))
                                .foregroundColor(first ? Color(hex: deepBlue) : .primary)
                            Divider()
                                .frame(width: screenWidth * 0.35, height: 4)
                                .overlay(Color(hex: deepBlue))
//                                .opacity(opacity1)
                                .offset(x: dividerOffset)
                                
                        }
                        .frame(width: screenWidth * 0.48, height: screenHeight * 0.044)
                        .onTapGesture {
                            if tabIndex == 0 {
                                firestoreManager.scroll_up = true
                            } else {
                                tabIndex = 0
                            }
                            
                        }
                       
                        Spacer()
                        VStack(spacing: 10){
                            (Text(Image(systemName: "figure.stand.line.dotted.figure.stand")) +  Text(" REQUESTS"))
                                .font(.headline.weight(.black))
                            .foregroundColor(second ? Color(hex: deepBlue) : .primary)
                            Divider()
                                .frame(width: screenWidth * 0.35, height: 3.5)
                                .overlay(Color(hex: deepBlue))
                                .opacity(opacity2)
                                .offset(x: dividerOffset + (screenWidth * 0.48))
                        }
                        .frame(width: screenWidth * 0.48, height: screenHeight * 0.044)
                        .onTapGesture {
                            if tabIndex == 1 {
                                firestoreManager.scroll_up = true
                            } else {
                                tabIndex = 1
                            }
                        }
                        Spacer()
                    }
                    Divider()
//                    .background(colorScheme == .dark ? .clear : Color(hex: greyBackground))
                    /*
                     Views for home screen
                     */
                    TabView(selection: $tabIndex){
                        ListingsView().tag(0)
                        RequestsView().tag(1)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .animation(.easeIn(duration: 0.2), value: tabIndex)
                    /*Animation for tab view change*/
                   .onChange(of: tabIndex) { value in
                       withAnimation {
                           dividerOffset = CGFloat(value) * (screenWidth * 0.499)
                       }
                   }
                    Divider()
                } //: VStack
                
                .onChange(of: tabIndex){ value in
                    if tabIndex == 0 {
                        withAnimation{
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
                    .offset(x: screenWidth * 0.35, y: screenHeight * 0.31)
                }
                
                
            } //: ZStack
            .ignoresSafeArea(.keyboard)
            .onAppear{
                if firestoreManager.listings_tab {
                    tabIndex = 0
                    firestoreManager.listings_tab = false
                } else if firestoreManager.requests_tab {
                    tabIndex = 1
                    firestoreManager.requests_tab = false
                }
                
            }
            .navigationBarBackButtonHidden(true)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
            HomeScreen()
            .environmentObject(FirestoreManager())
    }
}
