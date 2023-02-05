//
//  SignInButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/25/23.
//

import SwiftUI

struct SignInButton: View {
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true
    @AppStorage("signedin") var isSignedIn: Bool = false
    @Binding var email: String
    @Binding var password: String
    @State private var loggedIn: Bool = false
    @State private var username_temp: String = ""
    @State private var error_alert: Bool = false
    @State private var error_message: String = ""
    @EnvironmentObject var firestoreManager : FirestoreManager
    @EnvironmentObject var authentication: AuthManager
    @AppStorage("username") var username_system: String = ""
    
    
    var body: some View {
        Button(action: {
            LightFeedback()
            Task{
                loggedIn = await authentication.signIn(email: email, password: password, error_alert: $error_alert, error_message: $error_message, username_temp: $username_temp)
            }
            if loggedIn {
                username_system = username_temp
                isOnboardingViewActive = false
                isSignedIn = true
            }
        }) {
            ZStack {
                // Blue Button background
                RoundedRectangle(cornerRadius: 33)
                    .fill(Color.init(hex: deepBlue))
                    .frame(width: 202, height: 64)
                
                // Putting Sign Up and Icon side-by-side
                HStack {
                    // Sign Up Text
                    Text("SIGN IN")
                        .font(
                            .system(size:30, weight: .bold)
                        )
                        .foregroundColor(.white)
                        .padding(3)
                } //: HStack
            } //: ZStack
        } //: Button
        .alert("Error Signing In", isPresented: $error_alert, actions: {}, message: {Text(error_message)} )
    }
}

struct SignInButton_Previews: PreviewProvider {
    static var previews: some View {
        SignInButton(email: .constant("DAHA@daha.com"), password:.constant("12345"))
        
    }
}

