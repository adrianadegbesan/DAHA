//
//  DeleteUserView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/14/23.
//

import SwiftUI

struct DeleteUserView: View {
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = false
    @AppStorage("signedin") var isSignedIn: Bool = true
    @AppStorage("termsagreed") var agreedToTerms: Bool = true
    @AppStorage("university") var university: String = ""
    @AppStorage("username") var username_system: String = ""
    @AppStorage("email") var email_system: String = ""
    @AppStorage("id") var user_id = ""
    @AppStorage("isDarkMode") private var isDarkMode = "System"
    
    @State private var firstPresented = false
    @State private var isPresented = false
    @State private var error_alert = false
    @State private var error_message = ""
    @State private var password = ""
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authentication : AuthManager
    
    var body: some View {
            VStack(alignment: .leading){
                HStack {
                    HStack {
                        Image(systemName: "trash.circle")
                            .foregroundColor(.red)
                        Spacer()
                    }
                    .frame(width: screenWidth * 0.1)
                    Text("Delete Account")
                        .foregroundColor(.red)
                }
//                Divider()
            }
            .onTapGesture {
                firstPresented = true
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
                            user_id = ""
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


struct DeleteUserView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteUserView()
    }
}
