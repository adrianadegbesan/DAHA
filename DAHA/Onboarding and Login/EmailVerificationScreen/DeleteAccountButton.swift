//
//  DeleteAccountButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/13/23.
//

import SwiftUI

struct DeleteAccountButton: View {
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = false
    @AppStorage("signedin") var isSignedIn: Bool = true
    @AppStorage("termsagreed") var agreedToTerms: Bool = true
    @AppStorage("university") var university: String = ""
    @AppStorage("username") var username_system: String = ""
    @AppStorage("email") var email_system: String = ""
    @AppStorage("isDarkMode") private var isDarkMode = "System"
    
    @State private var firstPresented = false
    @State private var isPresented = false
    @State private var error_alert = false
    @State private var error_message = ""
    @State private var password = ""
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authentication : AuthManager
    
    var body: some View {
        Button(action: {
            firstPresented = true
        }){
            Text("Delete Account")
                    .font(
                        .system(size:25, weight: .bold)
                    )
                    .foregroundColor(.red)
        }
        .alert("Enter Password", isPresented: $firstPresented, actions: {
            TextField("Password", text: $password)
                .foregroundColor(Color(hex: deepBlue))
            Button("Continue", role: .destructive, action: {
                Task {
                    let success = await authentication.reauthenticate(password: $password, error_message: $error_message)
                    if success {
                         isPresented = true
                    } else {
                        error_alert = true
                    }
                }
            })
        }, message: {Text("Please enter your password to continue")})
        .alert("Delete Account", isPresented: $isPresented, actions: {
            Button("Delete", role: .destructive, action: {
                Task {
                    let success = await authentication.deleteUser()
                    if success {
                        isOnboardingViewActive = true
                        isSignedIn = false
                        agreedToTerms = false
                        university = ""
                        username_system = ""
                        email_system = ""
                        isDarkMode = "System"
                    } else {
                        error_message = "Please check your network connection and try again later"
                        error_alert = true
                    }
                }
            })
        }, message: { Text("Are you sure you want to delete your account? This action cannot be reversed.")})
        .alert("Error Deleting Account", isPresented: $error_alert, actions: {}, message: {Text(error_message)})
    }
}

struct DeleteAccountButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAccountButton()
    }
}
