//
//  DMButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

// Button used to go to DM Page
struct DMButton: View {
    @State var shouldNavigate = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
//        NavigationLink(destination: {}) {
        Button(action: {
//            MediumFeedback()
            shouldNavigate = true
            
        }) {
            Image(systemName: "paperplane")
                    .headerImage()
            
            NavigationLink(destination: DMScreen(), isActive: $shouldNavigate){
                EmptyView()
            }
    //        }
        }
        .foregroundColor(colorScheme == .dark ? .white : .black)
    }
}

struct DMButton_Previews: PreviewProvider {
    static var previews: some View {
        DMButton()
    }
}
