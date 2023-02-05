//
//  LoginScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/25/23.
//

import SwiftUI

struct LoginScreen: View {
    
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true
    @AppStorage("accountcreated") var isAccountCreated: Bool = false
    @AppStorage("university") var university: String = ""
    @AppStorage("username") var username_system: String = ""
    @AppStorage("email") var email_system: String = ""
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        ZStack{
            ScrollView{
                Spacer().frame(height: screenHeight * 0.15)
                Image("Logo")
                    .padding(.bottom, 60)
                CustomInputField(imageName: "envelope.fill", placeholderText: "Email", text: $email, secure: false)
                    .padding(.bottom, 30)
                    .padding(.horizontal, screenWidth * 0.2)
                CustomInputField(imageName: "lock.fill", placeholderText: "Password", text: $password, secure: true)
                    .padding(.bottom, 40)
                    .padding(.horizontal, screenWidth * 0.2)
                SignInButton(email: $email, password: $password)
                ForgotPasswordButton()
            }
//            .background(.ultraThinMaterial)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button(action: {
                    hideKeyboard()
                }){
                        Text(Image(systemName: "multiply"))
                            .foregroundColor(.gray)
                }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
            .environmentObject(AuthManager())
    }
}

