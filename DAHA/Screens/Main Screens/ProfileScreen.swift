//
//  ProfileScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

// Profile Screen
struct ProfileScreen: View {
    
    @AppStorage("username") var username_system: String = ""
    @State private var tabIndex : Int = 0
    @State private var tabs : [String] = ["MY POSTS", "SAVED"]
    @EnvironmentObject var firestoreManager : FirestoreManager
    @EnvironmentObject var appState : AppState
    @Environment(\.colorScheme) var colorScheme
    @State private var opacity1 = 1.0
    @State private var opacity2 = 0.0
    @State private var opacity3 = 0.0
    @State private var first = true
    @State private var second = false
    @State private var third = false
    @State private var dividerOffset: CGFloat = 0
    
    @AppStorage("unread") var unread: Bool = false

    var body: some View {
        ZStack {
            VStack(spacing: 0){
                HeaderView(title: "@\(username_system)", showMessages: false, showSettings: true, showSearchBar: false, slidingBar: true, tabIndex: $tabIndex, tabs: tabs, screen: "User")
//                .frame(alignment: .top)
                
                HStack {
                    Spacer()

                    HStack{
                        VStack{
                            if firestoreManager.metrics_loading{
                                ProgressView()
                            } else {
                                Text("\(firestoreManager.post_count)")
                                    .fontWeight(.bold)
                                    .foregroundColor(firestoreManager.post_count == 0 ? .secondary : .primary)
                            }
                            HStack{
                                Text("Posts")
                                    .fontWeight(.semibold)
                                    .scaleEffect(0.9)
                            }
                        }

                        Spacer().frame(width: 25)

                        VStack{
                            if firestoreManager.metrics_loading{
                                ProgressView()
                            } else {
                                Text("\(firestoreManager.saved_count)")
                                    .fontWeight(.bold)
                                    .foregroundColor(firestoreManager.saved_count == 0 ? .secondary : .primary)
                            }
                            HStack{
                                Text("Saved")
                                    .fontWeight(.semibold)
                                    .scaleEffect(0.9)
                            }
                        }
                    }
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(colorScheme == .dark ? .gray : .black, lineWidth: 2))


                    Spacer()

                }
                .padding(.bottom, 20)
//                .background(colorScheme == .dark ? .clear : Color(hex: greyBackground))
                
                
                
                /*Tab View Section Headers with animation*/
                HStack {
                   
                    Spacer()
                    VStack(spacing: 10){
                       (Text(Image(systemName: "squareshape.split.2x2")) + Text(" POSTS"))
                            .font(.headline.weight(.black))
                            .foregroundColor(first ? Color(hex: deepBlue) : .primary)
                        Divider()
                            .frame(width: screenWidth * 0.25, height: 3.5)
                            .overlay(Color(hex: deepBlue))
                            .cornerRadius(5)
                            .offset(x: dividerOffset,y: 1.5)
                            
                    }
                    .frame(width: screenWidth * 0.25, height: screenHeight * 0.044)
                    .onTapGesture {
                        tabIndex = 0
                    }
                   
                    Spacer()
                    VStack(spacing: 10){
                        (Text(Image(systemName: "bookmark.fill")) +  Text(" SAVED"))
                            .font(.headline.weight(.black))
                        .foregroundColor(second ? Color(hex: deepBlue) : .primary)
                        Divider()
                            .frame(width: screenWidth * 0.25, height: 3.5)
                            .overlay(Color(hex: deepBlue))
                            .opacity(opacity2)
                            .cornerRadius(5)
                            .offset(x: dividerOffset + (screenWidth * 0.25), y: 1.5)
                    }
                    .frame(width: screenWidth * 0.25, height: screenHeight * 0.044)
                    .onTapGesture {
                        tabIndex = 1
                    }
                    Spacer()
                    
                    VStack(spacing: 10){
                        (Text(Image(systemName: unread ? "paperplane.fill" : "paperplane")) +  Text(" DMs"))
                            .font(.headline.weight(.black))
                        .foregroundColor(third || unread ? Color(hex: deepBlue) : .primary)
                        .scaleEffect(1.15)
                        Divider()
                            .frame(width: screenWidth * 0.25, height: 3.5)
                            .overlay(Color(hex: deepBlue))
                            .opacity(opacity3)
                            .cornerRadius(5)
                            .offset(x: dividerOffset + (screenWidth * 0.5), y: 1.5)
                    }
                    .frame(width: screenWidth * 0.25, height: screenHeight * 0.044)
                    .onTapGesture {
                        tabIndex = 2
                    }
                    Spacer()
                }
                Divider()
//                .background(colorScheme == .dark ? .clear : Color(hex: greyBackground))
                
                TabView(selection: $tabIndex){
                    UserPostsView().tag(0)
                        .frame(width: screenWidth)
                    
                    SavedPostsView().tag(1)
                        .frame(width: screenWidth)
                    
                    DMScreen(profile: true).tag(2)
                        .frame(width: screenWidth)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeIn(duration: 0.2), value: tabIndex)
                .onChange(of: tabIndex) { value in
                    withAnimation {
                        dividerOffset = CGFloat(value) * (screenWidth * 0.318)
                    }
                }
                Divider()
            } //: VStack
            
            .onChange(of: tabIndex){ value in
                if tabIndex == 0 {
                    withAnimation {
                        first = true
                        second = false
                        third = false
//                        opacity1 = 1
//                        opacity2 = 0
//                        opacity3 = 0
                    }
                } else if tabIndex == 1{
                    withAnimation {
                        first = false
                        second = true
                        third = false
//                        opacity1 = 0
//                        opacity2 = 1
//                        opacity3 = 0
                    }
                } else {
                    withAnimation {
                        first = false
                        second = false
                        third = true
//                        opacity1 = 0
//                        opacity2 = 0
//                        opacity3 = 1
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
//            Task{
//                if appState.profileStart {
//                    appState.profileStart = false
//                    await firestoreManager.userPosts()
//                }
//
//            }
            if firestoreManager.listings_tab{
                tabIndex = 0
                firestoreManager.listings_tab = false
            } else if firestoreManager.requests_tab {
                tabIndex = 0
                firestoreManager.requests_tab = false
            }
            
            
        }
        .navigationBarBackButtonHidden(true)

    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
            .environmentObject(FirestoreManager())
    }
}
