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
    @EnvironmentObject var firestoreManager : FirestoreManager
    @FocusState private var keyboardFocused: Bool
    
    var body: some View {
        VStack{
            TextField("Does Anyone Have A...?", text: $query)
                .textFieldStyle(OutlinedTextFieldStyle(icon: Image(systemName: "magnifyingglass")))
                .focused($keyboardFocused)
                .submitLabel(.search)
                .onSubmit {
                    Task {
                        await firestoreManager.searchPosts(query: query.lowercased(), type: type, category: category)
                    }
                }
                .padding(.horizontal, screenWidth * 0.03)
                .padding(.bottom, 10)
            
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
        }
        PostScrollView(posts: $firestoreManager.search_results, loading: $firestoreManager.search_results_loading, screen: "Search", query: $query, type: $type, category: $category)
        .onAppear {
                Task {
                    await firestoreManager.searchPosts(query: query.lowercased(), type: type, category: category)
                }
        }
        .keyboardControl()
    }
      
 
}

struct SearchBarScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarScreen(query: .constant(""), category: .constant(""), type: .constant(""))
    }
}
