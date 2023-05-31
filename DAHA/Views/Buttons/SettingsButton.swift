//
//  SettingsButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

struct SettingsButton: View {
    @State private var shouldNavigate = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: {
//            MediumFeedback()
            shouldNavigate = true
            
        }) {
            Image(systemName: "gearshape")
                    .headerImage()
            
            NavigationLink(destination: SettingsScreen(), isActive: $shouldNavigate){
                EmptyView()
            }
            .buttonStyle(.plain)
        }
        .foregroundColor(colorScheme == .dark ? .white : .black)
        .buttonStyle(.plain)
    }
}

struct SettingsButton_Previews: PreviewProvider {
    static var previews: some View {
        SettingsButton()
    }
}
