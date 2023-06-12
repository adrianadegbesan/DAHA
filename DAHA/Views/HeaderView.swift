//
//  HeaderView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI
import Shimmer
//import SlidingTabView

// Header View utilised throughout this app
struct HeaderView: View {
    
    let title: String
    let showMessages: Bool
    let showSettings: Bool
    let showSearchBar: Bool
    let slidingBar : Bool
    var tabIndex : Binding<Int>?
    var tabs : [String]?
    var screen: String
    @State private var isAnimating: Bool = false
    
    @FocusState private var keyboardFocused: Bool
    @State private var query = ""
    @State private var category = ""
    @State private var type = ""
    @State private var shouldNavigate = false
    @State private var showExitButton: Bool = false
    @State private var connectedAlert: Bool = false
    @State var userID: String? 
    @State private var opacity: CGFloat = 0.0
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var firestoreManager : FirestoreManager
    @EnvironmentObject var network : Network
    @EnvironmentObject var appState : AppState
    
    @State private var shimmer: Bool = false
    
    
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
          
                HStack{
                    Image("Logo")
                        .scaleEffect(0.6)
                        .overlay(Rectangle().stroke(colorScheme == .dark ? .white : .clear, lineWidth: 2).scaleEffect(0.6))
                    ZStack {
                        
                        Rectangle()
                            // Specific dimensions of rounded rectangle
                            .frame(width: 170, height: colorScheme == .dark ? 66.4 : 65.5)
                            .cornerRadius(18, corners: [.topRight, .bottomRight])
                            .foregroundColor(.black)
                            .background((Rectangle().cornerRadius(18, corners: [.topRight, .bottomRight]).foregroundColor(colorScheme == .dark ? .white : .black).scaleEffect(1.018)))
                          
                            
                            
                        HStack{
                            Text(title)
                                .lineLimit(1)
                                .minimumScaleFactor(0.01)
                                .font(.system(size: screen == "User" ? 17 : 18.5, weight: .bold))
                                .scaleEffect(screen == "User" && title.count >= 10 ? 0.95 : 1)
                                .foregroundColor(.white)
//                                .opacity(screen == "Home" ? opacity : 1)
//                                .onAppear{
//                                    if screen == "Home" && appState.homeStart {
//                                        withAnimation(.easeIn(duration: 0.5)){
//                                            opacity = 1
//                                            appState.homeStart = false
//                                        }
//                                    }
//                                }
                                
                        }
                    }
                    .offset(x: -30)
                }
                .transition(.opacity)
                .scaleEffect(isAnimating ? 1.075 : 1.0)
                .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1), value: isAnimating)
                .onTapGesture{
                    if !isAnimating{
                        SoftFeedback()
                        isAnimating = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                           isAnimating = false
                        }
                    }
                 }
 
                
                Spacer()

                if showMessages {
                    
                    if network.connected == false {
                        Image(systemName: "wifi.slash")
                            .headerImage()
                            .foregroundColor(.red)
                            .transition(.opacity)
                            .onTapGesture {
                                connectedAlert = true
                            }
                    }
//                    SearchButton()
//                        .padding(.trailing, 3)
                    DMButton()
                    
                } else if showSettings {
                    SettingsButton()
                } else if screen == "UserTemp" {
                    if userID != nil {
                            HStack{
                                if firestoreManager.metricsTemp_loading{
                                    ProgressView()
                                } else {
                                    Text("\(firestoreManager.postTemp_count)")
                                        .font(.system(size: 20, weight: .bold))
                                        .minimumScaleFactor(0.75)
                                        .foregroundColor(Color(hex: deepBlue))
//                                        .foregroundColor(firestoreManager.postTemp_count == 0 ? .secondary : .primary)
                                    
                                }
                            }
                            .frame(width: 50, height: 50)
                            .background(Circle().stroke(colorScheme == .dark ? .gray : .black, lineWidth: 2))
                            .modifier(shimmerOnTap())
                            .padding(.trailing, 21)
                            .padding(.top, 3)
                        
                        
                    }
                }
                
            } //: HStack
                
            if screen == "Saved" {
                Divider()
                    .frame(height: 0.5)
                    .overlay(colorScheme == .dark ? Color(hex: darkGrey) : .black)
            }
            
            HStack{
                if screen == "Home"{
                    TextField("", text: $query, prompt: Text("Does Anyone Have A...?").font(.system(size: 15.5, weight: .bold)))
                        .textFieldStyle(OvalTextFieldStyle(icon: Image(systemName: "magnifyingglass"), text: $query))
                        .background(colorScheme == .dark ? Color(hex: dark_scroll_background).cornerRadius(20) : Color(hex: light_scroll_background).cornerRadius(20))
                        .shadow(color: .black.opacity(0.2), radius: 2.5, x: 0, y: 2.5)
                        .submitLabel(.search)
                        .onSubmit {
                            if !(query.trimmingCharacters(in: .whitespacesAndNewlines) == "" && category == "" && type == ""){
                                if !firestoreManager.search_results.isEmpty{
                                    firestoreManager.search_results_previous = firestoreManager.search_results
                                    firestoreManager.search_last_previous = firestoreManager.search_last
                                }
//                                firestoreManager.search_results.removeAll()
                                shouldNavigate = true
                            }
                        }
                        .focused($keyboardFocused)
                        .padding(.leading, screenWidth * 0.03)
                        .padding(.trailing, !keyboardFocused ? screenWidth * 0.03 : screenWidth * 0.004)
                        .padding(.bottom, 25)
                    
                    if showExitButton {
                        Text("Cancel")
                            .font(.system(size: 17, weight: .semibold))
                            .padding(.bottom, 24)
                            .padding(.trailing, 15)
                            .onTapGesture {
//                                SoftFeedback()
                                withAnimation(.easeIn(duration: 0.3)){
                                    query = ""
                                    keyboardFocused = false
                                }
                            }
                            .foregroundColor(Color(hex: deepBlue))
                            
                    }
                    
                    NavigationLink(destination: SearchBarScreen(query: $query, category: $category, type: $type), isActive: $shouldNavigate){
                        EmptyView()
                    }
                    .buttonStyle(.plain)
                }
                
                
            }
            .onChange(of: keyboardFocused){ value in
                if keyboardFocused{
                    withAnimation(.easeIn(duration: 0.35)){
                        showExitButton = true
                    }
                } else if !keyboardFocused{
                    withAnimation(.easeIn(duration: 0.35)){
                        showExitButton = false
                    }
                }
            }
         
            
        } //: VStack
        .onAppear {
            if userID != nil && screen == "UserTemp"{
                Task {
                    firestoreManager.postTemp_count = 0
                    await firestoreManager.getUserMetrics(cur_id: userID!)
                }
            }
        }
        .alert("Network Connection Lost", isPresented: $connectedAlert, actions: {}, message: {Text("It looks like your internet connection was lost! Please check your connection and try again.")})
//        .background(colorScheme == .dark || screen == "Search" ? .clear : Color(hex: greyBackground))
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(title: "Stanford", showMessages: true, showSettings: false, showSearchBar: false, slidingBar: true, tabIndex: .constant(0), tabs: ["LISTINGS", "REQUESTS"], screen: "Home")
            .previewLayout(.sizeThatFits)
    }
}
