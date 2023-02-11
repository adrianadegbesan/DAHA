//
//  SearchScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

// Search Screen
struct SearchScreen: View {
    
    @State var query = ""
    @State var category = ""
    @State var type = ""
    @State var shouldNavigate = false
    @FocusState private var keyboardFocused: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { _ in
            VStack(spacing: 0) {
                HeaderView(title: "Search", showMessages: false, showSettings: false, showSearchBar: true, slidingBar: false, tabIndex: nil, tabs: nil)
                    .frame(alignment: .top)
             
                TextField("Does Anyone Have A...?", text: $query)
                    .textFieldStyle(OutlinedTextFieldStyle(icon: Image(systemName: "magnifyingglass")))
                    .submitLabel(.search)
                    .onSubmit {
                        shouldNavigate = true
                    }
                    .focused($keyboardFocused)
                    .padding(.horizontal, screenWidth * 0.06)
                    .padding(.bottom, 25)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                VStack {
                    HStack{
                        if category != ""{
                            
                            Text(Image(systemName: "multiply.circle.fill"))
                                .font(.system(size: 13, weight: .bold))
                                .background(Circle().fill(.white).scaleEffect(colorScheme == .dark ? 1 : 0.4))
                                .background(Circle().stroke(colorScheme == .dark ? .white : .black, lineWidth: colorScheme == .dark ? 1 : 3))
                                .disabled(keyboardFocused)
                                .onTapGesture {
                                    LightFeedback()
                                    withAnimation{
                                        hideKeyboard()
                                        category = ""
                                    }
                                }
                                .foregroundColor(.red)
                            
                            Label(category.uppercased(), systemImage: category_images[category] ?? "")
                                .lineLimit(1)
                                .foregroundColor(.white)
                                .font(.system(size: 13, weight: .bold))
                                .padding(10)
                                .background(Capsule().fill(Color(hex: category_colors[category] ?? "000000")))
                                .overlay(colorScheme == .dark ? Capsule().stroke(.white, lineWidth: 2) : Capsule().stroke(.black, lineWidth: 3))
                                .padding(.trailing, 10)
                            
                        } else {
                            Text(" . ")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.clear)
                                .background(Circle().stroke(.clear, lineWidth: 3))
                        }
                        
                            ChooseTypeButton(selected: $type)
                            .disabled(keyboardFocused)
                       
                    }
                    .padding(.bottom, 25)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                        SearchCategories(selected: $category)
                        .disabled(keyboardFocused)
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                    
                    Spacer()
                }
                .onTapGesture {
                    keyboardFocused = false
                }
                .opacity(keyboardFocused == true ? 0.2 : 1)
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

struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreen()
    }
}
