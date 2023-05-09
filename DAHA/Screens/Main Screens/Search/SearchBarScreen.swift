//
//  SearchBarScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

struct SearchBarScreen: View {
    
    @Binding var query : String
    @Binding var category : String
    @Binding var type : String
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var firestoreManager : FirestoreManager
    @EnvironmentObject var appState : AppState
    @FocusState private var keyboardFocused: Bool
    
    var body: some View {
        ZStack {
            VStack(spacing: 0){
                
                HStack{
                    Image(systemName: "chevron.left")
                        .font(.system(size: 22, weight: .bold))
                        .padding(.bottom, 10)
                        .padding(.top, 11)
                        .padding(.leading, 15)
                        .onTapGesture {
//                            SoftFeedback()
                            query = ""
                            dismiss()
                        }
                        .foregroundColor(Color(hex: deepBlue))
                    TextField("Does Anyone Have A...?", text: $query)
                        .textFieldStyle(OvalTextFieldStyle(icon: Image(systemName: "magnifyingglass"), text: $query))
                        .background(colorScheme == .dark ? Color(hex: dark_scroll_background).cornerRadius(20) : Color(hex: light_scroll_background).cornerRadius(20))
                        .focused($keyboardFocused)
                        .submitLabel(.search)
                        .onSubmit {
                            Task {
                                await firestoreManager.searchPosts(query: query.lowercased().trimmingCharacters(in: .whitespacesAndNewlines), type: type, category: category)
                            }
                        }
                        .padding(.horizontal, screenWidth * 0.03)
                        .padding(.bottom, 10)
                        .padding(.top, 12.5)
                    
                }
               
                
                HStack{
                    if category != "" {
                        Label(category.uppercased(), systemImage: category_images[category] ?? "")
                            .lineLimit(1)
                            .foregroundColor(.white)
                            .font(.system(size: 13, weight: .bold))
                            .padding(10)
                            .background(Capsule().fill(Color(hex: category_colors[category] ?? "000000")))
                            .overlay(colorScheme == .dark ? Capsule().stroke(.white, lineWidth: 2) : Capsule().stroke(.black, lineWidth: 2))
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
                
                Spacer()
                
                Divider()
//                    .frame(maxHeight : 4)
//                    .overlay(colorScheme == .light ? Color(hex: darkGrey) : .white)
//                    .padding(.top, 10)
                
                PostScrollView(posts: $firestoreManager.search_results, loading: $firestoreManager.search_results_loading, screen: "Search", query: $query, type: $type, category: $category)
            } //VSTACK

            .keyboardControl()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear {
            Task {
                await firestoreManager.searchPosts(query: query.lowercased().trimmingCharacters(in: .whitespacesAndNewlines), type: type, category: category)
            }
    }

    }
      
 
}

struct SearchBarScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarScreen(query: .constant(" "), category: .constant("General"), type: .constant(""))
            .environmentObject(FirestoreManager())
    }
}
