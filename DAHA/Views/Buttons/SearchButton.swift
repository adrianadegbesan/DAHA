//
//  SearchButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/9/23.
//

import SwiftUI

struct SearchButton: View {
    @State private var shouldNavigate = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: {
            shouldNavigate = true
            
        }) {
            Image(systemName: "magnifyingglass")
                    .headerImage()
            
            NavigationLink(destination: SearchScreen(navScreen: true), isActive: $shouldNavigate){
                EmptyView()
            }
            .buttonStyle(.plain)
        }
        .foregroundColor(colorScheme == .dark ? .white : .black)
        .buttonStyle(.plain)
    }
}

struct SearchButton_Previews: PreviewProvider {
    static var previews: some View {
        SearchButton()
    }
}
