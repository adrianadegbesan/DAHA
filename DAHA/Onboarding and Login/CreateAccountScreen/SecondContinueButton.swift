//
//  SecondContinueButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/11/23.
//

import SwiftUI
import FirebaseAuth

struct SecondContinueButton: View {
    
    @EnvironmentObject var firestoreManager : FirestoreManager
    @EnvironmentObject var authentication: AuthManager
    @Binding var firstName : String
    @Binding var lastName : String
    @Binding var username : String
    @Binding var password : String
    @Binding var reconfirm_password : String
    @Binding var error: Bool
    @Binding var error_message: String
    @State private var usernameInUse: Bool = false
    @State private var account_created: Bool = false
    @State private var errorCreatingAccountAlert: Bool = false
    @State private var shouldNavigate: Bool = false
    @Binding var uploading: Bool
    @AppStorage("university") var university: String = ""
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = false
    @AppStorage("signedin") var isSignedIn: Bool = false
    @AppStorage("username") var username_system: String = ""
    @AppStorage("email") var email_system: String = ""
    @Environment(\.colorScheme) var colorScheme

    
    
    var body: some View {
        Button(action: {
            if !uploading{
                LightFeedback()
                uploading = true
                Task {
                    let username_temp = username.replacingOccurrences(of: " ", with: "").lowercased()
                    let password_temp = password.replacingOccurrences(of: " ", with: "")
                    print(password)
                    let reconfirmpassword_temp = reconfirm_password.replacingOccurrences(of: " ", with: "")
                    let firstname_temp = firstName.replacingOccurrences(of: " ", with: "").lowercased()
                    let lastname_temp = lastName.replacingOccurrences(of: " ", with: "").lowercased()
                    
                    await firestoreManager.verifyUsername(username: username_temp, usernameInUse:$usernameInUse, cannot_verify:$errorCreatingAccountAlert)
                    print(usernameInUse)
                    if (usernameInUse){
                        error = true
                        error_message = "Username already in use"
                        usernameInUse.toggle()
                    } else if (password_temp.count < 6){
                        error = true
                        error_message = "Password length cannot be less than 6 characters"
                    } else if (password_temp != reconfirmpassword_temp){
                        error = true
                        error_message = "Passwords do not match"
                    } else if (username_temp.count < 5){
                        error = true
                        error_message = "Username length cannot be less than 5 characters"
                    } else if (username_temp.count > 9){
                        error = true
                        error_message = "Username length cannot be greater than 9 characters"
                    } else if (username_temp.isEmpty || password_temp.isEmpty || reconfirmpassword_temp.isEmpty || firstname_temp.isEmpty || lastname_temp.isEmpty){
                        error = true
                        error_message = "Please fill all fields"
                    } else {
                        //                    let cur_id = Auth.auth().currentUser?.uid
                        let cur_email = email_system
                        
                        
                        if cur_email != ""{
                            let current = UserModel(id: nil, username: username_temp, email: cur_email, firstname: firstname_temp, lastname: lastname_temp, channels: [], university: university, terms: false)
                            Task {
                                print(password_temp)
                                await authentication.createAccount(email: cur_email, password: password_temp, user: current, cannot_create: $errorCreatingAccountAlert, creation_complete: $account_created)
                                
                                print(account_created)
                                if account_created {
                                    username_system = username_temp.trimmingCharacters(in: .whitespaces)
                                    isSignedIn = true
                                    isOnboardingViewActive = false
                                }
                                shouldNavigate = account_created
                            }
                        }
                        else {
                            isOnboardingViewActive = true
                        }
                    }
                    uploading = false
                }
        }
        }){
            ZStack {
                // Blue Button background
                RoundedRectangle(cornerRadius: 33)
                    .fill(Color.init(hex: deepBlue))
                    .frame(width: 180, height: 55)
                    .overlay(Capsule().stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
                
                HStack {
                    // Continue Text
                    Text("CONTINUE")
                        .font(
                            .system(size:20, weight: .bold)
                        )
                        .foregroundColor(.white)
                        .padding(3)
                } //: HStack
            } //: ZStack
            NavigationLink(destination: TermsConditionsScreen().navigationBarHidden(true), isActive: $shouldNavigate){
                EmptyView()
            }
        } //:Button
        .alert("Error Creating Account", isPresented: $errorCreatingAccountAlert, actions: {}, message: {Text("There was an error creating your account, please check your network connection and try again later")})
    }
}


struct SecondContinueButton_Previews: PreviewProvider {
    static var previews: some View {
        SecondContinueButton(firstName: .constant("jack"), lastName:  .constant("jack"), username:  .constant("jack"), password:  .constant("jack"), reconfirm_password:  .constant("jack"), error: .constant(false), error_message: .constant(""), uploading: .constant(false))
            .environmentObject(FirestoreManager())
            .environmentObject(AuthManager())
    }
}
