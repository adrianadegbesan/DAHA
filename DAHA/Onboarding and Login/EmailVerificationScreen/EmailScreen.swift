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
    
    @State private var shouldNavigate = false
    
    @State var error_alert = false
    @State var error_message = ""
    
    @State var time = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @EnvironmentObject var authentication: AuthManager

    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack{
            LottieView(name: colorScheme == .dark ? "DAHA-Loading_dark" : "DAHA-Loading")
                .scaleEffect(0.4)
                .padding(.bottom, screenHeight * 0.5)
                .onReceive(time){ value in
                    if let currentUser = Auth.auth().currentUser {
                        authentication.reloadUser()
                        if currentUser.isEmailVerified {
                            verified = true
                            shouldNavigate = true
                        }
                    }
                }
            
            VStack{
                Spacer().frame(height: screenHeight * 0.35)
                Text("We've sent a verification email to your inbox. Please click the link to confirm your email address.")
                    .font(.system(size: 18, weight: .black))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                
                Text("If the verification email doesn't appear in your inbox, please check your spam folder.")
                    .font(.system(size: 14, weight: .black))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 10)
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
            
            NavigationLink(destination: TermsConditionsScreen().navigationBarBackButtonHidden(true), isActive: $shouldNavigate){
                EmptyView()
            }
        }
        .onAppear {
            
        // Check if user is already logged in and verified
            if let currentUser = Auth.auth().currentUser {
                if currentUser.isEmailVerified {
                    verified = true
                    shouldNavigate = true
                    return
                } else {
                    authentication.reloadUser()
                }
            }
            
            
            let _ = Auth.auth().addStateDidChangeListener { auth, user in
            if let currentUser = user {
                if currentUser.isEmailVerified {
                    verified = true
                    shouldNavigate = true
//                    time.invalidate()
                }
            } else {
                // User has logged out, reset app state
                isOnboardingViewActive = true
                isSignedIn = false
                agreedToTerms = false
                university = ""
                username_system = ""
                email_system = ""
                user_id = ""
                isDarkMode = "System"
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
