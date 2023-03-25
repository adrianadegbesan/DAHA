//
//  SignInButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/25/23.
//

import SwiftUI
import FirebaseAuth

struct SignInButton: View {
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true
    @AppStorage("signedin") var isSignedIn: Bool = false
    @AppStorage("termsagreed") var agreedToTerms: Bool = false
    @AppStorage("emailverified") var verified: Bool = false
    @Binding var email: String
    @Binding var password: String
    @Binding var uploading: Bool
    @State private var loggedIn: Bool = false
    @State private var username_temp: String = ""
    @State private var university_temp: String = ""
    @State private var terms_temp: Bool = false
    @State private var joined_temp: String = ""
    @State private var error_alert: Bool = false
    @State private var error_message: String = ""
    @EnvironmentObject var firestoreManager : FirestoreManager
    @EnvironmentObject var authentication: AuthManager
    @EnvironmentObject var messageManager: MessageManager
    @AppStorage("username") var username_system: String = ""
    @AppStorage("university") var university: String = ""
    @AppStorage("email") var email_system: String = ""
    @AppStorage("joined") var joinedAt = ""
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        Button(action: {
            LightFeedback()
            if !uploading{
                uploading = true
                Task{
                    try await Task.sleep(nanoseconds: 0_800_000_000)
                    //Sign in function with necessary variables
                    loggedIn = await authentication.signIn(email: email, password: password, error_alert: $error_alert, error_message: $error_message, username_temp: $username_temp, university_temp: $university_temp, joined_temp: $joined_temp, terms_temp: $terms_temp)
                    if loggedIn {
                        username_system = username_temp
                        university = university_temp
                        joinedAt = joined_temp
                        agreedToTerms = terms_temp
                        if Auth.auth().currentUser != nil{
                            email_system = Auth.auth().currentUser!.email!
                            verified =
                                Auth.auth().currentUser!.isEmailVerified
                        }
                    
                        Task{
                            //Get Posts on background thread
                            await firestoreManager.getListings()
                            await firestoreManager.getRequests()
                            await firestoreManager.getSaved()
                            await firestoreManager.userPosts()
                            await firestoreManager.getMetrics()
                            let _ = messageManager.getMessageChannels()
                        }
                        uploading = false
                        isOnboardingViewActive = false
                        isSignedIn = true
                    } else {
                        uploading = false
                    }
                }

            }
            
         
        }) {
            
            ZStack {
                // Blue Button background
                RoundedRectangle(cornerRadius: 33)
                    .fill(Color.init(hex: deepBlue))
                    .frame(width: 170, height: 58)
                    .overlay(Capsule().stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
                
                // Putting Sign Up and Icon side-by-side
                HStack {
                    // Sign Up Text
                    Text("SIGN IN")
                        .font(
                            .system(size:26, weight: .bold)
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
        SignInButton(email: .constant("DAHA@daha.com"), password:.constant("12345"), uploading: .constant(false))
        
    }
}

