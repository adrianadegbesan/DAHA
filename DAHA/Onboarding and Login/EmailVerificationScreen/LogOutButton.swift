//
//  LogOutButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/28/23.
//

import SwiftUI

struct LogOutButton: View {
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = false
    @AppStorage("signedin") var isSignedIn: Bool = true
    @AppStorage("termsagreed") var agreedToTerms: Bool = true
    @AppStorage("university") var university: String = ""
    @AppStorage("username") var username_system: String = ""
    @AppStorage("email") var email_system: String = ""
    @AppStorage("joined") var joinedAt = ""
    @AppStorage("isDarkMode") private var isDarkMode = "System"
    
    @State private var isPresented = false
    @State private var error_alert = false
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var authentication: AuthManager
    
    var body: some View {
        Button(action: {
            isPresented = true
        }){
            Text("LOG OUT")
                    .font(
                        .system(size:25, weight: .bold)
                    )
                .foregroundColor(Color.init(hex: darkGrey))
        }
        .alert("Log Out", isPresented: $isPresented, actions: {
            Button("Log Out", role: .destructive, action: {
                Task {
                    let _ = await authentication.signOut()
                    isOnboardingViewActive = true
                    isSignedIn = false
                    agreedToTerms = false
                    university = ""
                    username_system = ""
                    email_system = ""
                    joinedAt = ""
                    isDarkMode = "System"
                }
            })
        }, message: { Text("Are you sure you want to log out?")})
    }
}

struct LogOutButton_Previews: PreviewProvider {
    static var previews: some View {
        LogOutButton()
    }
}
