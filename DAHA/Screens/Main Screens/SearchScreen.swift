//
//  SearchTest.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/15/23.
//

import SwiftUI

struct SearchScreen: View {
    
    @State var query = ""
    @State var category = ""
    @State var type = ""
    @State var shouldNavigate = false
    @State var opacity = 1.0
    @FocusState private var keyboardFocused: Bool
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var firestoreManager : FirestoreManager
    @State var searched = false
    @State var navScreen : Bool?
    @State var isAnimating: Bool = false
    @State var isAnimating2: Bool = false
    
    @State var showExitButton: Bool = false
    
    var body: some View {
        GeometryReader { _ in
            VStack(spacing: 0) {
                
                
                if !searched && navScreen == nil{

                    HeaderView(title: "Search", showMessages: false, showSettings: false, showSearchBar: true, slidingBar: false, tabIndex: nil, tabs: nil, screen: "Search")
//                        .padding(.trailing, 15)
                        .frame(alignment: .top)
                        .transition(.opacity)

//                    Spacer().frame(height: screenHeight * 0.07)

                }
                
                HStack{
                    
//                    if searched {
//                        Image(systemName: "chevron.left")
//                            .font(.system(size: 22, weight: .heavy))
//                            .padding(.bottom, 25)
//                            .padding(.top, 3)
//                            .padding(.leading, 15)
//                            .onTapGesture {
//                                SoftFeedback()
//                                withAnimation(.easeIn(duration: 0.3)){
//                                    opacity = 1
//                                    firestoreManager.search_results.removeAll()
//                                    keyboardFocused = false
//                                    searched = false
//                                }
//                            }
//                            .foregroundColor(Color(hex: deepBlue))
//
//                    }
                    
                    
                    TextField("Does Anyone Have A...?", text: $query)
//                        .textFieldStyle(OutlinedTextFieldStyle(icon: Image(systemName: "magnifyingglass")))
                        .textFieldStyle(OvalTextFieldStyle(icon: Image(systemName: "magnifyingglass"), text: $query))
                        .background(colorScheme == .dark ? Color(hex: dark_scroll_background).cornerRadius(20) : Color(hex: light_scroll_background).cornerRadius(20))
                        .submitLabel(.search)
                        .onSubmit {
                            if !(query.trimmingCharacters(in: .whitespacesAndNewlines) == "" && category == "" && type == ""){
                                /*Search database*/
                                if !firestoreManager.search_results.isEmpty{
                                    firestoreManager.search_results.removeAll()
                                }
                                Task {
                                    await firestoreManager.searchPosts(query: query.lowercased().trimmingCharacters(in: .whitespacesAndNewlines), type: type, category: category)
                                }
                                withAnimation(.easeIn(duration: 0.3)){
                                    searched = true
                                }
                            }
                        }
                        .focused($keyboardFocused)
                        .padding(.leading, screenWidth * 0.03)
                        .padding(.trailing, !searched && !keyboardFocused ? screenWidth * 0.03 : screenWidth * 0.005)
                        .padding(.bottom, 18)
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                    
                    
                    if showExitButton {
                        Text("Cancel")
                            .font(.system(size: 17, weight: .semibold))
                            .padding(.bottom, 18)
                            .padding(.trailing, 10)
                            .onTapGesture {
                                SoftFeedback()
                                withAnimation(.easeIn(duration: 0.3)){
                                    opacity = 1
                                    firestoreManager.search_results.removeAll()
                                    query = ""
                                    keyboardFocused = false
                                    searched = false
                                    
                                }
                            }
                            .foregroundColor(Color(hex: deepBlue))
                            
                    }
                }
                .padding(.top, searched ? 24 : 5)
                .onChange(of: keyboardFocused){ value in
                    if keyboardFocused{
                        withAnimation(.easeIn(duration: 0.35)){
                            showExitButton = true
                        }
                    } else if !keyboardFocused && !searched {
                        withAnimation(.easeIn(duration: 0.35)){
                            showExitButton = false
                        }
                    }
                }
                .onChange(of: searched){ value in
                    if searched{
                        withAnimation(.easeIn(duration: 0.35)){
                            showExitButton = true
                        }
                    } else if !keyboardFocused && !searched {
                        withAnimation(.easeIn(duration: 0.35)){
                            showExitButton = false
                        }
                    }
                    
                }
             
                if !searched {
                    VStack {
                        /*Search Buttons and Categories*/
                        SearchButtons(keyboardFocused: $keyboardFocused, category: $category, type: $type)
                            .transition(.opacity)
                            .ignoresSafeArea(.keyboard, edges: .bottom)
                            .padding(.top, 15)
                        
                        Spacer().frame(maxHeight: 15)
                        
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        
                        SearchCategories(selected: $category)
                            .transition(.opacity)
                            .disabled(keyboardFocused)
                            .ignoresSafeArea(.keyboard, edges: .bottom)
                        
                        Spacer()
                    }
                    
                    
                    .onTapGesture {
                        keyboardFocused = false
                    }
                    .opacity(opacity)
                    .onChange(of: keyboardFocused){ value in
                        if keyboardFocused{
                            withAnimation {
                                if colorScheme == .dark{
                                    opacity = 0.1
                                } else {
                                    opacity = 0.04
                                }
                                
                            }
                        } else{
                            withAnimation {
                                opacity = 1
                            }
                        }
                    }
                    
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    
                } else {
                    //Searched 
                    VStack(spacing: 0){
                        HStack{
                            if category != "" {
                                Label(category.uppercased(), systemImage: category_images[category] ?? "")
                                    .lineLimit(1)
                                    .foregroundColor(.white)
                                    .font(.system(size: 13, weight: .bold))
                                    .padding(10)
                                    .background(Capsule().fill(Color(hex: category_colors[category] ?? "000000")))
                                    .overlay(colorScheme == .dark ? Capsule().stroke(.white, lineWidth: 2) : Capsule().stroke(.black, lineWidth: 3))
                                    .scaleEffect(isAnimating ? 1.15 : 1.0)
                                    .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1), value: isAnimating)
                                    .onLongPressGesture(minimumDuration: 0.5) {
                                         SoftFeedback()
                                         isAnimating = true
                                         DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                            isAnimating = false
                                         }
                                     }
                                    .padding(.trailing, 10)
                            }
                            
                            if type != "" {
                                Label(type.uppercased(), systemImage: type_images[type] ?? "")
                                    .lineLimit(1)
                                    .foregroundColor(.white)
                                    .font(.system(size: 13, weight: .bold))
                                    .padding(10)
                                    .background(Capsule().fill(.black))
                                    .overlay( colorScheme == .dark ? Capsule().stroke(.white, lineWidth: 2) : Capsule().stroke(.clear, lineWidth: 3))
                                    .scaleEffect(isAnimating2 ? 1.15 : 1.0)
                                    .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1), value: isAnimating2)
                                    .onLongPressGesture(minimumDuration: 0.5) {
                                         SoftFeedback()
                                         isAnimating2 = true
                                         DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                            isAnimating2 = false
                                         }
                                     }
                                    .padding(.trailing, 10)
                            }
                               
                        }
                        Spacer().frame(height: (category == "" && type == "") ? 10 : 20)
                        
                        Divider()
//                            .frame(maxHeight : 4)
//                            .overlay(colorScheme == .light ? Color(hex: darkGrey) : .white)
//                            .padding(.top, 10)
                        
                        PostScrollView(posts: $firestoreManager.search_results, loading: $firestoreManager.search_results_loading, screen: "Search", query: $query, type: $type, category: $category)
                        
                    }
                    .transition(.opacity)
                    
                }
                Divider()
            }//: VStack
            .frame(width: screenWidth)
            .onTapGesture {
                hideKeyboard()
            }
            
            .onDisappear{
                if navScreen != nil{
                    if navScreen! {
                        firestoreManager.search_results.removeAll()
                    }
                }
            }
        }
            .ignoresSafeArea(.keyboard, edges: .bottom)
//            .keyboardControl()
            .navigationBarBackButtonHidden(true)
      
    }
}

struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreen()
            .environmentObject(FirestoreManager())
    }
}
