//
//  RefreshButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/15/23.
//

import SwiftUI

struct RefreshButton: View {
    @EnvironmentObject var firestoreManager : FirestoreManager
    @Environment(\.colorScheme) var colorScheme 
    var tabIndex : Binding<Int>?
    var screen : String
    
    var body: some View {
        Button(action: {
            SoftFeedback()
            if screen == "Home"{
                if tabIndex?.wrappedValue == 0{
                    Task{
                        await firestoreManager.getListings()
                    }
                } else if tabIndex?.wrappedValue == 1{
                    Task{
                        await firestoreManager.getRequests()
                    }
                }
            }
        }){
            Image(systemName: "arrow.clockwise")
                .headerImage()
//                .foregroundColor(Color(hex: deepBlue))
        }
        .foregroundColor(colorScheme == .dark ? .white : .black)
    }
}

struct RefreshButton_Previews: PreviewProvider {
    static var previews: some View {
        RefreshButton(screen: "Home")
    }
}
