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
import FirebaseStorage


class FirestoreManager: ObservableObject {
    
    @AppStorage("university") var university: String = ""
    @AppStorage("username") var username_system: String = ""
    @AppStorage("email") var email_system: String = ""
    @Environment(\.dismiss) var dismiss
    
    
    @State var posts: [PostModel] = []
    @State var saved_posts: [PostModel] = []
    @State var my_posts: [PostModel] = []
    @State var search_results: [PostModel] = []
    
    
    private var db = Firestore.firestore()
    private var storage = Storage.storage()
    
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
    
    func uploadImages(images: [UIImage]) async -> [String]{
        
//        var result : [String : [String]]
        var urls : [String] = []
//        var ids : [String] = []
        
        var error_found = false
        let storageRef = storage.reference()
        
        if !images.isEmpty{
            for image in images {
                let imageData = image.jpegData(compressionQuality: 0.8)
                guard imageData != nil else {
                    return ["error"]
                }
                let cur_id = "\(university)_images/\(UUID().uuidString).jpg"
//                ids.append(cur_id)
                
                let fileRef = storageRef.child(cur_id)
                
                do {
                    _ = try await fileRef.putDataAsync(imageData!)
                    let url = try await fileRef.downloadURL()
                    urls.append(url.absoluteString)
                }
                catch {
                    error_found = true
                }
            }
        }
        
        if error_found == true{
            return ["error"]
        } else {
            return urls
        }
    }
    
    func makePost(post: PostModel, images: [UIImage], post_created: Binding<Bool>, completion: @escaping (Error?) -> Void) async {
        
        var urls : [String] = []
        if !images.isEmpty{
            urls = await uploadImages(images: images)
        }
        print(urls)
        
        if urls == ["error"]{
            completion(uploadError("Couldn't upload images"))
        }
        
        var post_temp = post
        
        post_temp.imageURLs.append(contentsOf: urls)
        
        let cur_id = Auth.auth().currentUser?.uid
        
        if cur_id == nil{
            completion(uploadError("User Account Error"))
        }
        
        post_temp.userID = cur_id!
        post_temp.username = username_system
        post_temp.channel = university
        post_temp.price = "\(post.price)"
        
        var ref: DocumentReference? = nil
        
        do {
            ref = try db.collection("\(university)_Posts").addDocument(from: post_temp){ err in
                if let err = err{
                    completion(uploadError(err.localizedDescription))
                } else {
                    print("Post was completed with ID: \(ref!.documentID)")
                    post_created.wrappedValue = true
                    print(post_created.wrappedValue)
                }
            }
        }
        catch {
            completion(uploadError("Error uploading post"))
        }
    }
    
    

    
    
    
    
}

struct uploadError: Error {
    let message: String
    
    init(_ message : String){
        self.message = message
    }
    
    public var localizedDescription: String{
        return message
    }
}
