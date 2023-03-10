//
//  LogOutView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/14/23.
//

import SwiftUI

struct LogOutView: View {
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = false
    @AppStorage("signedin") var isSignedIn: Bool = true
    @AppStorage("termsagreed") var agreedToTerms: Bool = true
    @AppStorage("university") var university: String = ""
    @AppStorage("username") var username_system: String = ""
    @AppStorage("email") var email_system: String = ""
    @AppStorage("id") var user_id = ""
    @AppStorage("isDarkMode") private var isDarkMode = "System"
    @AppStorage("joined") var joinedAt = ""
    @AppStorage("emailverified") var verified: Bool = true
    
    @State private var isPresented = false
    @State private var error_alert = false
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authentication : AuthManager
    
    var body: some View {
        Button(action: {
            isPresented = true
        }){
            VStack(alignment: .leading) {
                HStack {
                    HStack {
                        Image(systemName: "door.left.hand.open")
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        Spacer()
                    }
                    .frame(width: screenWidth * 0.1)
                    
                    Text("Log Out")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
//                Divider()
            }
        }
        .alert("Log Out", isPresented: $isPresented, actions: {
            Button("Log Out", role: .destructive, action: {
                Task {
                    let success = await authentication.signOut()
                    if success {
                        isOnboardingViewActive = true
                        isSignedIn = false
                        agreedToTerms = false
                        university = ""
                        username_system = ""
                        email_system = ""
                        user_id = ""
                        joinedAt = ""
                        isDarkMode = "System"
                        verified = false
                    } else {
                        error_alert = true
                    }
                }
            })
        }, message: { Text("Are you sure you want to log out?")})
        .alert("Error Logging Out", isPresented: $error_alert, actions: {}, message: {Text("Please check your network connection and try again later")})
    }
}

struct LogOutView_Previews: PreviewProvider {
    static var previews: some View {
        LogOutView()
            .environmentObject(AuthManager())
    }
}
