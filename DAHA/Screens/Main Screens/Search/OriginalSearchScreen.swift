//
//  SearchScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

// Search Screen
struct OriginalSearchScreen: View {
    
    @State var query = ""
    @State var category = ""
    @State var type = ""
    @State var shouldNavigate = false
    @State var opacity = 1.0
    @FocusState private var keyboardFocused: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { _ in
            VStack(spacing: 0) {
                HeaderView(title: "Search", showMessages: false, showSettings: false, showSearchBar: true, slidingBar: false, tabIndex: nil, tabs: nil, screen: "Search")
                    .frame(alignment: .top)
             
                TextField("Does Anyone Have A...?", text: $query)
                    .textFieldStyle(OutlinedTextFieldStyle(icon: Image(systemName: "magnifyingglass")))
                    .submitLabel(.search)
                    .onSubmit {
                        if !(query.trimmingCharacters(in: .whitespacesAndNewlines) == "" && category == "" && type == ""){
                            shouldNavigate = true
                        }
                    }
                    .focused($keyboardFocused)
                    .background(Color.primary.opacity(0.05))
                    .padding(.horizontal, screenWidth * 0.06)
                    .padding(.bottom, 25)
               
                    .ignoresSafeArea(.keyboard, edges: .bottom)
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
                            opacity = 0.1
                        }
                    } else{
                        withAnimation {
                            opacity = 1
                        }
                    }
                }
                
                .ignoresSafeArea(.keyboard, edges: .bottom)
                
                Spacer()
                
                NavigationLink(destination: SearchBarScreen(query: $query, category: $category, type: $type), isActive: $shouldNavigate){
                    EmptyView()
                }
                PageBottomDivider()
//                Spacer()
            }//: VStack
            .onTapGesture {
                hideKeyboard()
            }
        }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .keyboardControl()
      
    }
}

struct OriginalSearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        OriginalSearchScreen()
    }
}
