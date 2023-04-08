//
//  AuthViewModel.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/11/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class AuthManager: ObservableObject {
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true
    @AppStorage("signedin") var isSignedIn: Bool = false
    @AppStorage("termsagreed") var agreedToTerms: Bool = false
    @AppStorage("university") var university: String = ""
    @AppStorage("username") var username_system: String = ""
    @AppStorage("email") var email_system: String = ""
    @AppStorage("accountcreated") var isAccountCreated: Bool = false
    @AppStorage("isDarkMode") private var isDarkMode = "System"
    @AppStorage("fcmtoken") private var token = ""
    @Published var userSession: FirebaseAuth.User?
    
    private var db = Firestore.firestore()
    
    init(){
        self.userSession = Auth.auth().currentUser
        if (self.userSession != nil){
            let verified =   userSession!.isEmailVerified
            print("DEBUG: The current User Session is \(self.userSession!)")
            print("Email is \(verified)")
            
        } else {
            print("DEBUG: The current User Session is nil")
        }
        
        if (self.userSession == nil) { //Log out if user.session is nil
            isOnboardingViewActive = true
            isSignedIn = false
            agreedToTerms = false
            university = ""
            username_system = ""
            email_system = ""
            isDarkMode = "System"
        }
    }
    
    /*Function for creating an account with auth's create user and posting the user data to the database*/
    func createAccount(email: String, password: String, user: UserModel, cannot_create: Binding<Bool>, creation_complete: Binding<Bool>, error_message: Binding<String>) async {
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            let cur_id = Auth.auth().currentUser?.uid
            var user_temp = user
            user_temp.id = cur_id ?? ""
            user_temp.joinedAt = nil
            let usernameModel = UsernameModel(id: cur_id ?? "", username: user.username)
            
            let batch = db.batch()
            
            do {
                
                let userRef = db.collection("Users").document(user_temp.id)
                let usernameRef = db.collection("Usernames").document(usernameModel.username)
                
                batch.setData(user_temp.dictionaryRepresentation, forDocument: userRef)
                batch.setData(usernameModel.dictionaryRepresentation, forDocument: usernameRef)
                batch.updateData(["fcmToken": token], forDocument: userRef)
                
                try await batch.commit()
                creation_complete.wrappedValue = true

            }
            
            catch {
                print("error uploading")
                print(error.localizedDescription)
                error_message.wrappedValue = "There was an error creating your account, please check your network connection and try again later."
                cannot_create.wrappedValue = true
            }
        }
        catch AuthErrorCode.emailAlreadyInUse{
            error_message.wrappedValue = "This email is already in use"
            cannot_create.wrappedValue = true
        }
        catch {
            error_message.wrappedValue = "There was an error creating your account, please check your network connection and try again later."
            cannot_create.wrappedValue = true
        }
    }
    
    /*
     Function for sending a verification email to a user
     */
    func sendVerificationEmail() -> Bool{
        let user = Auth.auth().currentUser
        var result = false
        
        if user != nil{
            user?.sendEmailVerification(completion: { (error) in
                if let error = error {
                    print("Error sending verification email: \(error.localizedDescription)")
                    result = false
                } else {
                    print("Verification email sent successfully")
                    result = true
                }
            })
        } else {
            return false
        }
           
        return result
    }
    
    /*
     Function for signing in user
     */
    func signIn(email: String, password: String, error_alert: Binding<Bool>, error_message: Binding<String>, username_temp: Binding<String>, university_temp: Binding<String>, joined_temp: Binding<String>, terms_temp: Binding<Bool>) async -> Bool {
        
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            let cur_id = Auth.auth().currentUser?.uid
            if cur_id == nil {
                error_alert.wrappedValue = true
                error_message.wrappedValue = "Couldn't find account"
                return false
            }
            do {
                let doc = try await db.collection("Users").document(cur_id!).getDocument()
                let document = doc.data()
                username_temp.wrappedValue = document?["username"] as? String ?? ""
                university_temp.wrappedValue = document?["university"] as? String ?? ""
                let date = document?["joinedAt"] as? Timestamp ?? Timestamp(date: Date.now)
                let formatter = DateFormatter()
                formatter.dateStyle = .long
                formatter.timeStyle = .none
                joined_temp.wrappedValue = formatter.string(from: date.dateValue())
                terms_temp.wrappedValue = document?["terms"] as! Bool
                let fcmtoken_temp = document?["fcmToken"] as? String ?? ""
                if  fcmtoken_temp != token {
                    if cur_id != nil{
                        try await db.collection("Users").document(cur_id!).updateData(["fcmToken" : token])
                    }
                }
                return true
            }
            catch {
                print("couldn't find")
                error_alert.wrappedValue = true
                error_message.wrappedValue = "Couldn't find account"
                return false
                
            }
        }
        catch AuthErrorCode.userDisabled {
            error_alert.wrappedValue = true
            error_message.wrappedValue = "Account is disabled"
            return false
        }
        catch AuthErrorCode.wrongPassword {
            error_alert.wrappedValue = true
            error_message.wrappedValue = "Invalid Email or Password"
            return false
        }
        
        catch AuthErrorCode.invalidEmail{
            error_alert.wrappedValue = true
            error_message.wrappedValue = "Invalid Email or Password"
            return false
        }
        
        catch {
            error_alert.wrappedValue = true
            error_message.wrappedValue = "Please check your network connection and try again later"
            print(error.localizedDescription)
            return false
        }
    }
    
    /*
     Function for signing out user
     */
    func signOut() async -> Bool{
        do {
            let cur_id = Auth.auth().currentUser?.uid
            if cur_id != nil{
                do {
                   let userRef = db.collection("Users").document(cur_id!)
                   try await userRef.updateData(["fcmToken" : FieldValue.delete()])
                }
                catch {
                    print("could not delete fcm token")
                }
            }
            try Auth.auth().signOut()
            return true
            
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    /*
     Function for reloading user for email verification check
     */
    func reloadUser() {
        Auth.auth().currentUser?.reload(completion: { error in
            if let error = error {
                print("Error reloading user: \(error.localizedDescription)")
            }
        })
    }
    
    /*
     Function for deleting account
     */
    func deleteUser() async -> Bool{
        var success = false
        let user = Auth.auth().currentUser
        if user?.uid == nil {
            return false
        }
        
        if user?.uid == "" {
            return false
        }
        
        let usernameRef = db.collection("Usernames").document(username_system)
        let userRef = db.collection("Users").document(user!.uid)
        let batch = db.batch()
        
        batch.deleteDocument(usernameRef)
        batch.deleteDocument(userRef)
        
        print("attempting to delete account")
        
        do {
            try await batch.commit()
            try await user?.delete()
            success = true
        }
        catch {
            print(error.localizedDescription)
            print("failed to delete account")
            return false
        }
        
        return success
    }
    
    
    /*
     Function for editing username
     */
    func editUsername(oldUsername: String, newUsername : Binding<String>, error_message: Binding<String>) async -> Bool {
       
        
        if newUsername.wrappedValue.replacingOccurrences(of: " ", with: "") == "" {
            error_message.wrappedValue = "Please enter a new username"
            return false
        } else if (newUsername.wrappedValue.replacingOccurrences(of: " ", with: "").count < 4){
            error_message.wrappedValue = "Username length cannot be less than 4 characters"
            return false
        } else if (newUsername.wrappedValue.replacingOccurrences(of: " ", with: "").count > 12){
            error_message.wrappedValue = "Username length cannot be greater than 12 characters"
            return false
        }
        
        let cur_id = Auth.auth().currentUser?.uid
        var not_found = false
        
        let newUsername_temp = newUsername.wrappedValue.replacingOccurrences(of: " ", with: "").lowercased()
        
        if cur_id != nil {
            let userRef = db.collection("Users").document(cur_id!)
            let usernameRef = db.collection("Usernames").document(oldUsername)
            let batch = db.batch()
            
            do {
                let snapshot = try await db.collection("Usernames").whereField("username", isEqualTo: newUsername_temp).getDocuments()
                not_found = snapshot.isEmpty
                
                if not_found {
                    
                    let newUsernameModel = UsernameModel(id: cur_id!, username: newUsername_temp)
                    let newRef = db.collection("Usernames").document(newUsername_temp)
                    
                    batch.updateData(["username": newUsername_temp], forDocument: userRef)
                    batch.deleteDocument(usernameRef)
                    batch.setData(newUsernameModel.dictionaryRepresentation, forDocument: newRef)
                    try await batch.commit()
                    
                    return true
                    
                } else {
                    error_message.wrappedValue = "Username is already is use"
                    return false
                }
               
            }
            catch {
                error_message.wrappedValue = "Unable to update username, please try again later."
                return false
            }
        }
        return true
    }
    
    /*
     Function for changing password
     */
    func changePassword(password: Binding<String>, newPassword: Binding<String>, error_message: Binding<String>) async -> Bool{
        let authenticated = await reauthenticate(password: password, error_message: error_message)
        if !authenticated{
            return false
        } else {
            let user = Auth.auth().currentUser
            if user != nil {
                if newPassword.wrappedValue.contains(" "){
                    error_message.wrappedValue = "New password cannot contain empty spaces"
                    return false
                }
                
                if (newPassword.wrappedValue.count < 6){
                    error_message.wrappedValue = "Password length cannot be less than 6 characters"
                    return false
                }
                
                do {
                    try await user?.updatePassword(to: newPassword.wrappedValue)
                    return true
                }
                catch {
                    print("The error is \(error.localizedDescription)")
                    error_message.wrappedValue = "Please check your network connection and try again later"
                    return false
                }
            } else {
                error_message.wrappedValue = "Please check your network connection and try again later"
                return false
            }
        }
    }
    
    /*
     Function for sending password reset email
     */
    func sendPasswordReset(email: String, error_alert: Binding<Bool>, success_alert: Binding<Bool>){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error != nil{
                error_alert.wrappedValue = true
            } else {
                success_alert.wrappedValue = true
            }
        }
    }
    
    /*
     Function for updating user terms state
     */
    func hasAgreedToTerms() async -> Bool{
        
        let cur_id = Auth.auth().currentUser?.uid
        
        if cur_id == nil {
            return false
        }
        
        do {
            let userRef = db.collection("Users").document(cur_id!)
            try await userRef.updateData([
                "terms" : true
            ])
            return true
        }
        catch {
            print("Unable to send terms agreement to database")
            return false
        }
    }
    
    /*
     Function for reauthenticating user
     */
    func reauthenticate(password: Binding<String>, error_message: Binding<String>) async -> Bool {
        
        let user = Auth.auth().currentUser
        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: email_system, password: password.wrappedValue)
        
        if user != nil{
            do {
                try await user?.reauthenticate(with: credential)
                return true
            }
            catch AuthErrorCode.wrongPassword {
                error_message.wrappedValue = "Incorrect password, please try again"
                return false
            }
            catch {
                print("The error is \(error.localizedDescription)")
                error_message.wrappedValue = "Please check your network connection and try again later"
                return false
            }
            
        } else {
            error_message.wrappedValue = "Please check your network connection and try again later"
            return false
        }
    }
    

}
