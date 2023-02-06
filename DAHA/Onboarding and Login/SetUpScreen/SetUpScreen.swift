//
//  SetUpScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI


struct SetUpScreen: View {
    @EnvironmentObject var firestoreManager : FirestoreManager
    var body: some View {
            ZStack {

                VStack {
                  
                    Spacer()
                    Image("Logo")
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
