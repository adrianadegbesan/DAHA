//
//  FirestoreManager.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/9/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift


class FirestoreManager: ObservableObject {
    
    @AppStorage("accountcreated") var isAccountCreated: Bool = false
    
    
    private var db = Firestore.firestore()
    
    func verifyDomain(domain: String, schoolFound: Binding<Bool>, cannot_verify: Binding<Bool>, uni_temp: Binding<String>) async {
        var found: Bool = false
        var uni: String = ""
        print("The domain is \(domain)")
        
        do {
            let snapshot = try await db.collection("Universities").whereField("Domain", isEqualTo: domain).getDocuments()
            found = !snapshot.isEmpty
            if (found){
                let doc = snapshot.documents
                print(doc[0].data())
                let document = doc[0].data()
                uni = document["Name"] as! String
                print(uni)
                uni_temp.wrappedValue = uni
            }
            print("found = \(found)")
            schoolFound.wrappedValue = found
        }
        catch {
            print("couldn't find")
            found = false
            cannot_verify.wrappedValue = true
        }
    }
    
    func verifyUsername(username: String, usernameInUse: Binding<Bool>, cannot_verify: Binding<Bool>) async {
        var not_found: Bool = false
        
        do {
            let snapshot = try await db.collection("Users").whereField("username", isEqualTo: username).getDocuments()
            not_found = snapshot.isEmpty
            
            if(!not_found){
                usernameInUse.wrappedValue = true
            }
        }
        catch {
            print(error.localizedDescription)
            print("Couldn't verify")
            cannot_verify.wrappedValue = true
        }
    }

    
    func createAccount(email: String, password: String, user: UserModel, cannot_create: Binding<Bool>, creation_complete: Binding<Bool>) async {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        do {
            try await Auth.auth().currentUser?.link(with: credential)
            do {
                try db.collection("Users").document(user.id!).setData(from: user)
                creation_complete.wrappedValue = true
            }
            
            catch {
                print("error uploading")
                print(error.localizedDescription)
                cannot_create.wrappedValue = true
            }
        }
        catch AuthErrorCode.providerAlreadyLinked{
            do {
                try db.collection("Users").document(user.id!).setData(from: user)
                creation_complete.wrappedValue = true
            }
            catch {
                cannot_create.wrappedValue = true
            }
        }
        catch {
            cannot_create.wrappedValue = true
        }
    }
}
