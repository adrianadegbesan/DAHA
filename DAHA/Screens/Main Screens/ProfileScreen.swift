//
//  ProfileScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI
import BottomSheet

// Profile Screen
struct ProfileScreen: View {
    
    @AppStorage("username") var username_system: String = ""
    @State private var tabIndex : Int = 0
    @State private var tabs : [String] = ["MY POSTS", "SAVED"]
    @EnvironmentObject var firestoreManager : FirestoreManager
    @Environment(\.colorScheme) var colorScheme
    @State var opacity1 = 1.0
    @State var opacity2 = 0.0
    @State var first = true
    @State var second = false
    @State private var bottomSheetPosition: BottomSheetPosition = .relative(0.15)
    @State private var expanded : Bool = false
    @State private var retracted : Bool = true

    var body: some View {
        ZStack {
            VStack(spacing: 0){
                HeaderView(title: "@\(username_system)", showMessages: false, showSettings: true, showSearchBar: false, slidingBar: true, tabIndex: $tabIndex, tabs: tabs, screen: "Profile")
                .frame(alignment: .top)
                
                
                HStack {
                    Spacer()
                    VStack(spacing: 10){
                       (Text(Image(systemName: "person.circle")) + Text(" POSTS"))
//                        (Text(Image(systemName: "cart.circle")) + Text(" LISTINGS"))
                            .font(.headline.weight(.black))
                            .foregroundColor(first ? Color(hex: deepBlue) : .primary)
                        Divider()
                            .frame(width: screenWidth * 0.35, height: 3.5)
                            .overlay(Color(hex: deepBlue))
                            .opacity(opacity1)
                            
                    }
                    .frame(width: screenWidth * 0.48, height: screenHeight * 0.044)
                    .onTapGesture {
                        bottomSheetPosition = .relative(0.15)
                        tabIndex = 0
                    }
                   
                    Spacer()
                    VStack(spacing: 10){
                        (Text(Image(systemName: "bookmark.fill")) +  Text(" SAVED"))
//                        (Text(Image(systemName: "figure.stand.line.dotted.figure.stand")) +  Text(" REQUESTS"))
                            .font(.headline.weight(.black))
                        .foregroundColor(second ? Color(hex: deepBlue) : .primary)
                        Divider()
                            .frame(width: screenWidth * 0.35, height: 3.5)
                            .overlay(Color(hex: deepBlue))
                            .opacity(opacity2)
                    }
                    .frame(width: screenWidth * 0.48, height: screenHeight * 0.044)
                    .onTapGesture {
                        bottomSheetPosition = .relative(0.15)
                        tabIndex = 1
                    }
                    Spacer()
                }
                .background(colorScheme == .dark ? .clear : Color(hex: greyBackground))
                
                
                TabView(selection: $tabIndex){
                    UserPostsView().tag(0)
                    SavedPostsView().tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeIn(duration: 0.2), value: tabIndex)
                
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
                .offset(x: screenWidth * 0.35, y: screenHeight * 0.31)
            }
        } //: ZStack
        .onTapGesture {
            bottomSheetPosition = .relative(0.15)
        }
        .bottomSheet(bottomSheetPosition: $bottomSheetPosition, switchablePositions: [.relative(0.15), .relativeTop(0.75), .relativeTop(0.88)], headerContent: {
                    VStack(alignment: .leading){
                        HStack{
                            Spacer().frame(width: screenWidth * 0.02)
                            Text(Image(systemName: "paperplane"))
                                .font(
                                    .system(size:21, weight: .heavy)
                                )
                            Text("Direct Messages")
                                .font(
                                    .system(size:20, weight: .heavy)
                                )
                            Spacer()
                        }
                        .frame(width: screenWidth)
                        .onTapGesture {
                            if retracted {
                                retracted = false
                                expanded = true
                                self.bottomSheetPosition = .relativeTop(0.75)
                            } else {
                                retracted = true
                                expanded = false
                                self.bottomSheetPosition = .relativeTop(0.15)
                            }
                            
                        }
                    }
                    .padding([.top, .leading, .bottom])
                }){
                    DMScreen()
                }
                .showDragIndicator(false)
                .enableContentDrag()
                .backgroundBlurMaterial(.system)
                .enableAppleScrollBehavior()
                .showDragIndicator(true)
                .onDragEnded{_ in 
                    if bottomSheetPosition == .relativeTop(0.75) || bottomSheetPosition == .relativeTop(0.88){
                        expanded = true
                        retracted = false
                    } else {
                        expanded = false
                        retracted = false
                    }
                }
//                .enableTapToDismiss(true)
//                .showCloseButton(true)

    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
            .environmentObject(FirestoreManager())
    }
}
