//
//  SetUpScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

//Initial Set Up Screen for logging on to DAHA
struct SetUpScreen: View {
    @EnvironmentObject var firestoreManager : FirestoreManager
    var body: some View {
            ZStack {
                // Sets background color to WHITE
                BackgroundColor(color: greyBackground)
                // Vertical Stack of Logo, Sign-up, and Login
                VStack {
                    // DAHA logo on top
                    Spacer()
                    Image("Logo")
                        .padding(.bottom, 20)
                    
                    // Sign Up Button in middle
                        SignUpButton()
                            .padding(.bottom, 10)
                           
                    // Login Button on bottom
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
