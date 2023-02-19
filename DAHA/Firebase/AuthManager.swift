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
    @AppStorage("university") var university: String = ""
    @AppStorage("username") var username_system: String = ""
    @AppStorage("email") var email_system: String = ""
    @AppStorage("accountcreated") var isAccountCreated: Bool = false
    @AppStorage("id") var user_id = ""
    @Published var userSession: FirebaseAuth.User?
    
    private var db = Firestore.firestore()
    
    init(){
        self.userSession = Auth.auth().currentUser
        if (self.userSession != nil){
            user_id = Auth.auth().currentUser!.uid
            print("DEBUG: The current User Session is \(self.userSession!)")
        } else {
            print("DEBUG: The current User Session is nil")
        }
        
        if (self.userSession == nil) {
            isOnboardingViewActive = true
        }
    }
    
    func createAccount(email: String, password: String, user: UserModel, cannot_create: Binding<Bool>, creation_complete: Binding<Bool>, error_message: Binding<String>) async {
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            let cur_id = Auth.auth().currentUser?.uid
            var user_temp = user
            user_temp.id = cur_id
            do {
                try db.collection("Users").document(user_temp.id!).setData(from: user_temp)
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
    
    func signIn(email: String, password: String, error_alert: Binding<Bool>, error_message: Binding<String>, username_temp: Binding<String>, university_temp: Binding<String>, terms_temp: Binding<Bool>) async -> Bool {
        
       var found: Bool = false
        do {
            print("password is \(password)")
            try await Auth.auth().signIn(withEmail: email, password: password)
            let cur_id = Auth.auth().currentUser?.uid
            do {
                let snapshot = try await db.collection("Users").whereField("id", isEqualTo: cur_id ?? "0").getDocuments()
                found = !snapshot.isEmpty
                if (found){
                    let doc = snapshot.documents
                    print(doc[0].data())
                    let document = doc[0].data()
                    username_temp.wrappedValue = document["username"] as! String
                    university_temp.wrappedValue = document["university"] as! String
                    terms_temp.wrappedValue = document["terms"] as! Bool
                    return true
                }
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
        
        return false
    }
    
    func signOut() -> Bool{
        do {
            try Auth.auth().signOut()
            return true
            
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func deleteUser() -> Bool{
        var success = false
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error{
                print(error.localizedDescription)
            } else {
                success = true
            }
        }
        return success
    }
    
    func editUsername(newUsername : Binding<String>, error_message: Binding<String>) async -> Bool {
       
        
        if newUsername.wrappedValue.replacingOccurrences(of: " ", with: "") == "" {
            error_message.wrappedValue = "Please enter a new username"
            return false
        } else if (newUsername.wrappedValue.replacingOccurrences(of: " ", with: "").count < 5){
            error_message.wrappedValue = "Username length cannot be less than 5 characters"
            return false
        } else if (newUsername.wrappedValue.replacingOccurrences(of: " ", with: "").count > 9){
            error_message.wrappedValue = "Username length cannot be greater than 9 characters"
            return false
        }
        
        let cur_id = Auth.auth().currentUser?.uid
        var not_found = false
        
        let newUsername_temp = newUsername.wrappedValue.replacingOccurrences(of: " ", with: "").lowercased()
        
        if cur_id != nil {
            let userRef = db.collection("Users").document(cur_id!)
            do {
                let snapshot = try await db.collection("Users").whereField("username", isEqualTo: newUsername_temp).getDocuments()
                not_found = snapshot.isEmpty
                if not_found {
                    try await userRef.updateData(["username" : newUsername_temp])
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
    
    func changePassword(password: Binding<String>, newPassword: Binding<String>, error_message: Binding<String>) async -> Bool{
        let authenticated = await reauthenticate(password: password, error_message: error_message)
        if !authenticated{
            return false
        } else {
            let user = Auth.auth().currentUser
            if user != nil {
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
        return true
    }
    
    func sendPasswordReset(email: String, error_alert: Binding<Bool>, success_alert: Binding<Bool>){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error != nil{
                error_alert.wrappedValue = true
            } else {
                success_alert.wrappedValue = true
            }
        }
    }
    
    func hasAgreedToTerms() async {
        if user_id == ""{
            return
        }
        do {
            let userRef = db.collection("Users").document(user_id)
            try await userRef.updateData([
                "terms" : true
            ])
        }
        catch {
            print("Unable to send terms agreement to database")
        }
    }
    
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
