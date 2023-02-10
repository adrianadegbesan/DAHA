//
//  SetUpScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI


struct SetUpScreen: View {
    @EnvironmentObject var firestoreManager : FirestoreManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
            ZStack {

                VStack {
                  
                    Spacer()
                    Image("Logo")
                        .overlay(Rectangle().stroke(colorScheme == .dark ? .white : .clear, lineWidth: 2))
                        .padding(.bottom, 20)
                   
                        SignUpButton()
                            .padding(.bottom, 10)
                           
                        LoginButton()
                    
                    Spacer()
                }
            }
    }
}

struct SetUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SetUpScreen()
        }
        .environmentObject(FirestoreManager())
        .environmentObject(AuthManager())
    }
}
