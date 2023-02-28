//
//  EmailScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/28/23.
//

import SwiftUI
import FirebaseAuth

struct EmailScreen: View {
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = false
    @AppStorage("signedin") var isSignedIn: Bool = true
    @AppStorage("termsagreed") var agreedToTerms: Bool = true
    @AppStorage("university") var university: String = ""
    @AppStorage("username") var username_system: String = ""
    @AppStorage("email") var email_system: String = ""
    @AppStorage("id") var user_id = ""
    @AppStorage("isDarkMode") private var isDarkMode = "System"
    @AppStorage("emailverified") var verified: Bool = false
    
    @State var error_alert = false
    @State var error_message = ""
    
    @EnvironmentObject var authentication: AuthManager

    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack{
            LottieView(name: colorScheme == .dark ? "DAHA-Loading_dark" : "DAHA-Loading")
                .scaleEffect(0.4)
                .padding(.bottom, screenHeight * 0.5)
            
            VStack{
                Spacer().frame(height: screenHeight * 0.35)
                Text("We've sent a verification email to your inbox. Please click the link to confirm your email address.")
                    .font(.system(size: 18, weight: .black))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                
                Text("Your account will be deleted in 24hrs if not verified")
                    .font(.system(size: 13.5, weight: .black))
                    .foregroundColor(.red)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 30)
                
                EmailResendButton(error_alert: $error_alert, error_message: $error_message)
                    .padding(.bottom, 15)
                LogOutButton()
                Spacer()
                
            }
        }
        .onAppear{
            
            if Auth.auth().currentUser == nil{
                isOnboardingViewActive = true
                isSignedIn = false
                agreedToTerms = false
                university = ""
                username_system = ""
                email_system = ""
                user_id = ""
                isDarkMode = "System"
            }
            let result = authentication.sendVerificationEmail()
            if !result{
                error_alert = true
            }
            Auth.auth().addStateDidChangeListener { auth, user in
                if user?.isEmailVerified == true {
                    verified = true
                }
            }
        }
        .alert("Error Verifying Email", isPresented: $error_alert, actions: {}, message: { Text("Please check your network connection and try again later")})
    }
}

struct EmailScreen_Previews: PreviewProvider {
    static var previews: some View {
        EmailScreen()
            .environmentObject(AuthManager())
    }
}
