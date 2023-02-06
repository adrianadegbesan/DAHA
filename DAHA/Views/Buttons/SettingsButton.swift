//
//  SettingsButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

struct SettingsButton: View {
    @State var shouldNavigate = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: {
//            MediumFeedback()
            shouldNavigate = true
            
        }) {
            Image(systemName: "gearshape")
                    .headerImage()
            
            NavigationLink(destination: Test(), isActive: $shouldNavigate){
                EmptyView()
            }
        }
        .foregroundColor(colorScheme == .dark ? .white : .black)
    }
}

struct SettingsButton_Previews: PreviewProvider {
    static var previews: some View {
        SettingsButton()
    }
}
