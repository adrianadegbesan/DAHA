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
    
    var body: some View {
        GeometryReader { _ in
            VStack(spacing: 0) {
                
                
                if !searched{
                    
                    HeaderView(title: "Search", showMessages: false, showSettings: false, showSearchBar: true, slidingBar: false, tabIndex: nil, tabs: nil, screen: "Search")
                        .frame(alignment: .top)
                    
                }
                
                HStack{
                    
                    if searched {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22, weight: .heavy))
                            .padding(.bottom, 25)
                            .padding(.leading, 15)
                            .onTapGesture {
                                SoftFeedback()
                                withAnimation(.easeIn(duration: 0.3)){
                                    opacity = 1
                                    firestoreManager.search_results.removeAll()
                                    keyboardFocused = false
                                    searched = false
                                }
                            }
                            .foregroundColor(Color(hex: deepBlue))
                            
                    }
                    
                    
                    TextField("Does Anyone Have A...?", text: $query)
                        .textFieldStyle(OutlinedTextFieldStyle(icon: Image(systemName: "magnifyingglass")))
                        .submitLabel(.search)
                        .onSubmit {
                            if !(query.trimmingCharacters(in: .whitespacesAndNewlines) == "" && category == "" && type == ""){
                                Task {
                                    await firestoreManager.searchPosts(query: query.lowercased().trimmingCharacters(in: .whitespacesAndNewlines), type: type, category: category)
                                }
                                withAnimation(.easeIn(duration: 0.3)){
                                    searched = true
                                }
                            }
                        }
                        .focused($keyboardFocused)
//                        .background(Color.primary.opacity(0.05))
                        .padding(.horizontal, !searched ? screenWidth * 0.058 : screenWidth * 0.03)
                        .padding(.bottom, 18)
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                }
                .padding(.top, searched ? 24 : 10)
             
                if !searched {
                    VStack {
                        
                        SearchButtons(keyboardFocused: $keyboardFocused, category: $category, type: $type)
                            .ignoresSafeArea(.keyboard, edges: .bottom)
                        
                        Spacer().frame(height: screenHeight * 0.02)
                        
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        
                        SearchCategories(selected: $category)
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
                                    .padding(.trailing, 10)
                            }
                               
                        }
                        Spacer().frame(height: 10)
                        
                        Divider()
                            .frame(maxHeight : 4 )
                            .overlay(colorScheme == .light ? Color(hex: darkGrey) : .white)
                            .padding(.top, 10)
                        
                        PostScrollView(posts: $firestoreManager.search_results, loading: $firestoreManager.search_results_loading, screen: "Search", query: $query, type: $type, category: $category)
                        
                    }
                    
                }
            
            }//: VStack
            .onTapGesture {
                hideKeyboard()
            }
        }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .keyboardControl()
      
    }
}

struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreen()
            .environmentObject(FirestoreManager())
    }
}
