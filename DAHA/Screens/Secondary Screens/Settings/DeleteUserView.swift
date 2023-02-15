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
    
    @State private var isPresented = false
    @State private var error_alert = false
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authentication : AuthManager
    
    var body: some View {
        Button(action: {
            isPresented = true
        }){
            VStack(alignment: .leading){
                HStack {
                    HStack {
                        Image(systemName: "poweroutlet.type.n.fill")
                            .foregroundColor(.red)
                        Spacer()
                    }
                    .frame(width: screenWidth * 0.1)
                    Text("Ctrl-Alt-Delete-Account")
                        .foregroundColor(.red)
                }
                Divider()
            }
           
        }
        .alert("Delete Account", isPresented: $isPresented, actions: {
            Button("Delete", role: .destructive, action: {
                Task {
                    let success = authentication.deleteUser()
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
                        error_alert = true
                    }
                }
            })
        }, message: { Text("Are you sure you want to delete your account? This action cannot be reversed.")})
        .alert("Error Deleting Account", isPresented: $error_alert, actions: {}, message: {Text("Please check your network connection and try again later")})
    }
}


struct DeleteUserView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteUserView()
    }
}
