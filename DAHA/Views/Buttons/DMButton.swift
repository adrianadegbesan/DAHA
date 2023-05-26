//
//  DMButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

// Button used to go to DM Page
struct DMButton: View {
    @State private var shouldNavigate = false
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("unread") var unread: Bool = false
    
    var body: some View {
        Button(action: {
            shouldNavigate = true
            
        }) {
            ZStack {
                Image(systemName: unread ? "paperplane.fill" : "paperplane")
                        .headerImage()
                        .foregroundColor(unread ? Color(hex: deepBlue) : .primary)
            }
            
            NavigationLink(destination: DMScreen(), isActive: $shouldNavigate){
                EmptyView()
            }
        }
        .foregroundColor(colorScheme == .dark ? .white : .black)
    }
}

struct DMButton_Previews: PreviewProvider {
    static var previews: some View {
        DMButton()
    }
}
