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
    @State private var account_error_message: String = ""
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
                    /*Accounts for emptyspaces*/
                    let username_temp = username.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "").lowercased()
                    let password_temp = password.replacingOccurrences(of: " ", with: "")
                    print(password)
                    let reconfirmpassword_temp = reconfirm_password.replacingOccurrences(of: " ", with: "")
                    let firstname_temp = firstName.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "").lowercased()
                    let lastname_temp = lastName.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "").lowercased()
                    
                    /*Checks if username is in use*/
                    await firestoreManager.verifyUsername(username: username_temp, usernameInUse:$usernameInUse, cannot_verify:$errorCreatingAccountAlert)
                    print(usernameInUse)
                    /*Username in use check*/
                    if (usernameInUse){
                        error = true
                        error_message = "Username already in use"
                        usernameInUse.toggle()
                    /*Password length check*/
                    } else if (password_temp.count < 6){
                        error = true
                        error_message = "Password length cannot be less than 6 characters"
                    /*Password empty space check*/
                    } else if password_temp.contains(" "){
                        error = true
                        error_message = "Password cannot contain empty spaces"
                    /*Passwords equal each other check*/
                    } else if (password_temp != reconfirmpassword_temp){
                        error = true
                        error_message = "Passwords do not match"
                    /*Username lower bound length check*/
                    } else if (username_temp.count < 5){
                        error = true
                        error_message = "Username length cannot be less than 5 characters"
                    /*Username upper bound length check*/
                    } else if (username_temp.count > 12){
                        error = true
                        error_message = "Username length cannot be greater than 12 characters"
                    /*Empty Field Check*/
                    } else if (username_temp.isEmpty || password_temp.isEmpty || reconfirmpassword_temp.isEmpty || firstname_temp.isEmpty || lastname_temp.isEmpty){
                        error = true
                        error_message = "Please fill all fields"
                    } else {
                        let cur_email = email_system
                        if cur_email != ""{
                            /*Create user model to post*/
                            let current = UserModel(id: nil, username: username_temp, email: cur_email, firstname: firstname_temp, lastname: lastname_temp, channels: [], university: university, terms: false)
                            Task {
                                print(password_temp)
                                /*Create account*/
                                await authentication.createAccount(email: cur_email, password: password_temp, user: current, cannot_create: $errorCreatingAccountAlert, creation_complete: $account_created, error_message: $account_error_message)
                                
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
        .alert("Error Creating Account", isPresented: $errorCreatingAccountAlert, actions: {}, message: {Text(account_error_message)})
    }
}


struct SecondContinueButton_Previews: PreviewProvider {
    static var previews: some View {
        SecondContinueButton(firstName: .constant("jack"), lastName:  .constant("jack"), username:  .constant("jack"), password:  .constant("jack"), reconfirm_password:  .constant("jack"), error: .constant(false), error_message: .constant(""), uploading: .constant(false))
            .environmentObject(FirestoreManager())
            .environmentObject(AuthManager())
    }
}
