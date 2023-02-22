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
    @Environment(\.colorScheme) var colorScheme
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State var progressOpacity = 0.0
    @State var screenOpacity = 1.0
    
    @State var uploading = false
    
    var body: some View {
        ZStack{
            ProgressView()
                .opacity(progressOpacity)
                .scaleEffect(2.5)
            ScrollView{
                Spacer().frame(height: screenHeight * 0.15)
                Image("Logo")
                    .overlay(Rectangle().stroke(colorScheme == .dark ? .white : .clear, lineWidth: 2))
                    .padding(.bottom, 60)
                CustomInputField(imageName: "envelope.fill", placeholderText: "Email", text: $email, secure: false)
                    .padding(.bottom, 30)
                    .padding(.horizontal, screenWidth * 0.2)
                CustomInputField(imageName: "lock.fill", placeholderText: "Password", text: $password, secure: true)
                    .padding(.bottom, 40)
                    .padding(.horizontal, screenWidth * 0.2)
                SignInButton(email: $email, password: $password, uploading: $uploading)
                ForgotPasswordButton()
            }
            .opacity(screenOpacity)
            .disabled(uploading)
        }
        .keyboardControl()
        .onTapGesture {
            hideKeyboard()
        }
        .onChange(of: uploading) { value in
            if uploading {
                withAnimation{
                    screenOpacity = 0.5
                    progressOpacity = 1.0
                }
            } else if !uploading {
                withAnimation {
                    screenOpacity = 1.0
                    progressOpacity = 0.0
                    
                }
            }
            
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
            .environmentObject(AuthManager())
    }
}

