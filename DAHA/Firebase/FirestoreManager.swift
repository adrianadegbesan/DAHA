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
    @AppStorage("username") var username_system: String = ""
    @AppStorage("email") var email_system: String = ""
    
    var posts: [PostModel] = []
    var saved_posts: [PostModel] = []
    var my_posts: [PostModel] = []
    
    
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
    
    func checkIfEmailExists(email: String) async -> Bool{
        
        do {
            let methods = try await Auth.auth().fetchSignInMethods(forEmail: email)
            if methods.isEmpty{
                return false
            } else {
                return true
            }
            
        }
        catch {
            return true
        }
    }
    
}
