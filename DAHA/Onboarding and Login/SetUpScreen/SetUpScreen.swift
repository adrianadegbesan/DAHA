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
    @State private var isAnimating : Bool = false
    
    var body: some View {
            ZStack {

                VStack {
                  
                    Spacer()
                    Image("Logo")
                        .overlay(Rectangle().stroke(colorScheme == .dark ? .white : .clear, lineWidth: 2))
                        .scaleEffect(isAnimating ? 1.075 : 1.0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1), value: isAnimating)
                        .onTapGesture{
                            if !isAnimating{
                                SoftFeedback()
                                isAnimating = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                   isAnimating = false
                                }
                            }
                         }
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
