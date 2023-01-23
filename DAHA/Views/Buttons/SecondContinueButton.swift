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
    @AppStorage("university") var university: String = ""
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = false
    @AppStorage("accountcreated") var isAccountCreated: Bool = false
    @AppStorage("username") var username_system: String = ""
    @AppStorage("email") var email_system: String = ""

    
    
    var body: some View {
        Button(action: {
            Task {
                let username_temp = username.replacingOccurrences(of: " ", with: "")
                let password_temp = password.replacingOccurrences(of: " ", with: "")
                let reconfirmpassword_temp = reconfirm_password.replacingOccurrences(of: " ", with: "")
                let firstname_temp = firstName.replacingOccurrences(of: " ", with: "")
                let lastname_temp = lastName.replacingOccurrences(of: " ", with: "")
                
                await firestoreManager.verifyUsername(username: username_temp, usernameInUse:$usernameInUse, cannot_verify:$errorCreatingAccountAlert)
                print(usernameInUse)
                if (usernameInUse){
                    error = true
                    error_message = "Username already in use"
                } else if (password_temp.count < 6){
                    error = true
                    error_message = "Password length cannot be less than 6 characters"
                } else if (password_temp != reconfirmpassword_temp){
                    error = true
                    error_message = "Passwords do not match"
                } else if (username_temp.count < 5){
                    error = true
                    error_message = "Username length cannot be less than 5 characters"
                } else if (username_temp.isEmpty || password_temp.isEmpty || reconfirmpassword_temp.isEmpty || firstname_temp.isEmpty || lastname_temp.isEmpty){
                    error = true
                    error_message = "Please fill all fields"
                } else {
                    let cur_id = Auth.auth().currentUser?.uid
                    let cur_email = email_system
                    
                    username_system = username_temp
                    if cur_id != nil && cur_email != ""{
                        let current = UserModel(id: cur_id, username: username_temp, email: cur_email, firstname: firstname_temp, lastname: lastname_temp, channels: [], university: university)
                        Task {
                            await firestoreManager.createAccount(email: cur_email, password: password_temp, user: current, cannot_create: $errorCreatingAccountAlert, creation_complete: $account_created)
                            if account_created {
                                isAccountCreated = true
                            }
                        }
                    }
                    else {
                        isOnboardingViewActive = true
                    }
                }
            }
            
        }){
            ZStack {
                // Blue Button background
                RoundedRectangle(cornerRadius: 33)
                    .fill(Color.init(hex: deepBlue))
                    .frame(width: 180, height: 55)
                
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
        } //:Button
        .alert("Error Creating Account", isPresented: $errorCreatingAccountAlert, actions: {}, message: {Text("There was an error creating your account, please check your network connection and try again later")})
    }
}


struct SecondContinueButton_Previews: PreviewProvider {
    static var previews: some View {
        SecondContinueButton(firstName: .constant("jack"), lastName:  .constant("jack"), username:  .constant("jack"), password:  .constant("jack"), reconfirm_password:  .constant("jack"), error: .constant(false), error_message: .constant(""))
            .environmentObject(FirestoreManager())
    }
}
