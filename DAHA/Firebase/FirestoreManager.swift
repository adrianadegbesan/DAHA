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

@MainActor
class FirestoreManager: ObservableObject {
    
    @AppStorage("university") var university: String = ""
    @AppStorage("username") var username_system: String = ""
    @AppStorage("email") var email_system: String = ""
    @AppStorage("signedin") var isSignedIn: Bool = false
    @AppStorage("termsagreed") var agreedToTerms: Bool = false
    @Environment(\.dismiss) var dismiss
    
    
    @Published var listings: [PostModel] = []
    @Published var listing_last : QueryDocumentSnapshot? = nil
    @Published var listings_loading: Bool = false
    
    @Published var requests: [PostModel] = []
    @Published var requests_last : QueryDocumentSnapshot? = nil
    @Published var requests_loading: Bool = false
    
    @Published var saved_posts: [PostModel] = []
    @Published var saved_last: QueryDocumentSnapshot? = nil
    @Published var saved_loading: Bool = false
    
    @Published var my_posts: [PostModel] = []
    @Published var user_last: QueryDocumentSnapshot? = nil
    @Published var my_posts_loading: Bool = false
    
    @Published var search_results: [PostModel] = []
    @Published var search_last: QueryDocumentSnapshot? = nil
    @Published var search_results_loading: Bool = false
    
    
    
    private var db = Firestore.firestore()
    private var storage = Storage.storage()
    
    init(){
        Task {
            if isSignedIn && agreedToTerms{
                await getListings()
                await getRequests()
                await getSaved()
                await userPosts()
            }
        }
    }
    
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
                let imageData = image.jpegData(compressionQuality: 0.7)
                guard imageData != nil else {
                    return ["error"]
                }
                let cur_id = "\(university)_images/\(UUID().uuidString).jpg"
                
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
    
    func convertPostModelToDictionary(post: PostModel) -> [String : Any] {
        var result : [String : Any] = [:]
        result["id"] = post.id
        result["title"] = post.title
        result["userID"] = post.userID
        result["username"] = post.username
        result["description"] = post.description
        result["postedAt"] = Timestamp(date: Date.now)
        result["condition"] = post.condition
        result["category"] = post.category
        result["price"] = post.price
        result["imageURLs"] = post.imageURLs
        result["channel"] = post.channel
        result["savers"] = post.savers
        result["type"] = post.type
        result["keywordsForLookup"] = post.keywordsForLookup
        
        return result
    }
    
    func makePost(post: PostModel, images: [UIImage], post_created: Binding<Bool>, completion: @escaping (Error?) -> Void) async {
        
        var urls : [String] = []
        if !images.isEmpty{
            urls = await uploadImages(images: images)
        }
        
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
    
        do {
                 
                 try db.collection("\(university)_Posts").document(post.id).setData(from: post_temp){ err in
                     if let err = err{
                         completion(uploadError(err.localizedDescription))
                     } else {
                         print("Post completed")
                         post_created.wrappedValue = true
                         print(post_created.wrappedValue)
                     }
                 }

         }
           catch {
               completion(uploadError("Error uploading post"))
           }
        
    }
    
    func deletePost(post: PostModel, deleted : Binding<Bool>, error_alert: Binding<Bool>) async {
        for url in post.imageURLs{
            let true_url = URL(string: url)
            if true_url != nil{
                do {
                    let storageRef = try storage.reference(for: true_url!)
                    storageRef.delete() { error in
                        if error != nil {
                            print("error deleting post")
                        }
                    }
                }
                catch {
                    print("error deleting post")
                }
            }
        }
        do {
            try await db.collection("\(university)_Posts").document(post.id).delete()
            deleted.wrappedValue = true
        }
        catch {
            error_alert.wrappedValue = true
        }
    }
    
    func retrieveSaved(post: PostModel)  -> Bool {
        let docRef = db.collection("\(university)_Posts").document(post.id)
        var result = false
        var list : [String] = []
        let id = Auth.auth().currentUser?.uid
        
        if id == nil {
            return false
        }
        
        docRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                list = dataDescription?["savers"] as? [String] ?? []
                if list.contains(id!){
                    result = true
                }
             } else {
                 print("Document does not exist")
             }
        }
        return result
        
    }
    
    func savePost(post: PostModel) async -> Bool {
        
        let postRef = db.collection("\(university)_Posts").document(post.id)
        
        let userId = Auth.auth().currentUser?.uid
        
        if userId == nil{
            return false
        }
        
        do {
            try await postRef.updateData(["savers": FieldValue.arrayUnion([userId!])])
            return true
            
        }
        catch {
            return false
        }
    }
    
    func unsavePost(post: PostModel) async -> Bool {
        let postRef = db.collection("\(university)_Posts").document(post.id)
        
        let userId = Auth.auth().currentUser?.uid
        
        if userId == nil{
            return false
        }
        
        do {
            try await postRef.updateData(["savers": FieldValue.arrayRemove([userId!])])
            return true
        }
        catch {
            return false
        }
    }
    
    
    func convertToPost(doc : QueryDocumentSnapshot) -> PostModel {
        let data = doc.data()
        let result = PostModel(id: data["id"] as? String ?? "",
                  title: data["title"] as! String,
                  userID: data["userID"] as! String,
                  username: data["username"] as! String,
                  description: data["description"] as! String,
                  postedAt: data["postedAt"] as? Timestamp ?? Timestamp(date: Date.now),
                  condition: data["condition"] as! String,
                  category: data["category"] as! String,
                  price: data["price"] as! String,
                  imageURLs: data["imageURLs"] as! [String],
                  channel: data["channel"] as! String,
                  savers: data["savers"] as! [String],
                  type: data["type"] as! String,
                  keywordsForLookup: data["keywordsForLookup"] as! [String])
        return result
    }
    
    func getListings() async {
        do {
            listings_loading = true
                
            var temp: [PostModel] = []
            let snapshot = try await db.collection("\(university)_Posts").whereField("type", isEqualTo: "Listing").order(by: "postedAt", descending: true).limit(to: 10).getDocuments()
            let documents = snapshot.documents
            if !documents.isEmpty{
                listing_last = documents.last!
            }
            for document in documents{
                let post = convertToPost(doc: document)
                temp.append(post)
            }
            
            listings = temp
            listings_loading = false
        }
        catch {
            listings_loading = false
            print("error")
        }
    }
    
    func updateListings() async {
        do {
            var temp: [PostModel] = []
            if listing_last == nil{
                return
            }
            let snapshot = try await db.collection("\(university)_Posts").whereField("type", isEqualTo: "Listing").order(by: "postedAt", descending: true).start(afterDocument: listing_last!).limit(to: 10).getDocuments()
            
            let documents = snapshot.documents
            if !documents.isEmpty{
                listing_last = documents.last!
            } else {
                return
            }
            for document in documents{
                let post = convertToPost(doc: document)
                temp.append(post)
            }
            listings.append(contentsOf: temp)
        }
        
        catch {
            print("error updating listings")
        }
        
    }
    
    func getRequests() async {
        do {
            requests_loading = true
            var temp: [PostModel] = []
            let snapshot = try await db.collection("\(university)_Posts").whereField("type", isEqualTo: "Request").order(by: "postedAt", descending: true).limit(to: 10).getDocuments()
            let documents = snapshot.documents
            if !documents.isEmpty{
                requests_last = documents.last!
            }
            for document in documents{
                let post = convertToPost(doc: document)
                temp.append(post)
            }
            self.requests = temp
            requests_loading = false
            
        }
        catch {
            requests_loading = false
            print("error")
        }
    }
    
    func updateRequests() async {
        do {
            var temp: [PostModel] = []
            if requests_last == nil{
                return
            }
            let snapshot = try await db.collection("\(university)_Posts").whereField("type", isEqualTo: "Request").order(by: "postedAt", descending: true).start(afterDocument: requests_last!).limit(to: 10).getDocuments()
            
            let documents = snapshot.documents
            if !documents.isEmpty{
                listing_last = documents.last!
            } else {
                return
            }
            for document in documents{
                let post = convertToPost(doc: document)
                temp.append(post)
            }
            requests.append(contentsOf: temp)
        }
        
        catch {
            print("error updating requests")
        }
        
    }
    
    func getSaved() async {
        
        let userId = Auth.auth().currentUser?.uid
        
        do {
            saved_loading = true
            var temp: [PostModel] = []
            
            if userId == nil{
                return
            }
            
            let snapshot = try await db.collection("\(university)_Posts").whereField("savers", arrayContains: userId!).order(by: "postedAt", descending: true).limit(to: 10).getDocuments()
            let documents = snapshot.documents
            if !documents.isEmpty{
                saved_last = documents.last!
            }
            for document in documents{
                let post = convertToPost(doc: document)
                temp.append(post)
            }
            saved_posts = temp
            saved_loading = false
            
        }
        catch {
            saved_loading = false
            print("error")
        }
    }
    
    func updateSaved() async {
        let userId = Auth.auth().currentUser?.uid
        
        do {
            var temp: [PostModel] = []
            
            if userId == nil{
                return
            }
            
            if saved_last == nil{
                return
            }
            
            let snapshot = try await db.collection("\(university)_Posts").whereField("savers", arrayContains: userId!).order(by: "postedAt", descending: true).start(afterDocument: saved_last!).limit(to: 10).getDocuments()
            let documents = snapshot.documents
            if !documents.isEmpty{
                saved_last = documents.last!
            } else {
                return
            }
            for document in documents{
                let post = convertToPost(doc: document)
                temp.append(post)
            }
            saved_posts.append(contentsOf: temp)
            
        }
        catch {
            print("error updating saved")
        }
    }
    
    func userPosts() async {
        
        let userId = Auth.auth().currentUser?.uid
        
        do {
            my_posts_loading = true
            var temp: [PostModel] = []
            
            
            if userId == nil{
                return
            }
            
            
            let snapshot = try await db.collection("\(university)_Posts").whereField("userID", isEqualTo:userId!).order(by: "postedAt", descending: true).limit(to: 10).getDocuments()
            let documents = snapshot.documents
            if !documents.isEmpty{
               user_last = documents.last!
            }
            for document in documents{
                let post = convertToPost(doc: document)
                temp.append(post)
            }
            my_posts = temp
            my_posts_loading = false
            
        }
        catch {
            my_posts_loading = false
            print("error")
        }
    }
    
    func updateUserPosts() async {
        let userId = Auth.auth().currentUser?.uid
        
        do {
            var temp: [PostModel] = []
            
            
            if userId == nil{
                return
            }
            
            if user_last == nil{
                return
            }
            
            let snapshot = try await db.collection("\(university)_Posts").whereField("userID", isEqualTo:userId!).order(by: "postedAt", descending: true).start(afterDocument: user_last!).limit(to: 10).getDocuments()
            let documents = snapshot.documents
            if !documents.isEmpty{
               user_last = documents.last!
            } else {
                return
            }
            for document in documents{
                let post = convertToPost(doc: document)
                temp.append(post)
            }
            my_posts.append(contentsOf:temp)
            
        }
        catch {
            print("error updating user posts")
        }
    }
    
    func searchPosts(query : String, type: String, category: String) async {
        
       
        do {
            search_results_loading = true
            var temp: [PostModel] = []
            
            if type != "" && category != "" && query == ""{
                let snapshot = try await db.collection("\(university)_Posts").whereField("type", isEqualTo: type).whereField("category", isEqualTo: category).order(by: "postedAt", descending: true).limit(to: 10).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    temp.append(post)
                }
            }
            
            else if type == "" && category != "" && query == ""{
                let snapshot = try await db.collection("\(university)_Posts").whereField("category", isEqualTo: category).order(by: "postedAt", descending: true).limit(to: 10).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    temp.append(post)
                }
            }
            
            else if type != "" && category == "" && query == ""{
                let snapshot = try await db.collection("\(university)_Posts").whereField("type", isEqualTo: type).order(by: "postedAt", descending: true).limit(to: 10).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    temp.append(post)
                }
            }
            
            else if type != "" && category == ""{
                let snapshot = try await db.collection("\(university)_Posts").whereField("keywordsForLookup", arrayContains: query).whereField("type", isEqualTo: type).order(by: "postedAt", descending: true).limit(to: 10).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    temp.append(post)
                }
            }
            
            else if type == "" && category != ""{
                let snapshot = try await db.collection("\(university)_Posts").whereField("keywordsForLookup", arrayContains: query).whereField("category", isEqualTo: category).order(by: "postedAt", descending: true).limit(to: 10).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    temp.append(post)
                }
            }
            
            else if type != "" && category != ""{
                let snapshot = try await db.collection("\(university)_Posts").whereField("keywordsForLookup", arrayContains: query).whereField("type", isEqualTo: type).whereField("category", isEqualTo: category).order(by: "postedAt", descending: true).limit(to: 10).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    temp.append(post)
                }
            }
            
            
            else {
                let snapshot = try await db.collection("\(university)_Posts").whereField("keywordsForLookup", arrayContains: query).order(by: "postedAt", descending: true).limit(to: 10).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    temp.append(post)
                }
            }
            
            search_results = temp
            search_results_loading = false
            
        }
        catch {
            search_results_loading = false
            print("error")
        }

    }
    
    func updateSearch(query : String, type: String, category: String) async {
        
        if search_last == nil {
            return
        }
        
        do {
            search_results_loading = true
            var temp: [PostModel] = []
            
            if type != "" && category != "" && query == ""{
                let snapshot = try await db.collection("\(university)_Posts").whereField("type", isEqualTo: type).whereField("category", isEqualTo: category).order(by: "postedAt", descending: true).start(afterDocument: search_last!).limit(to: 10).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                } else {
                    return
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    temp.append(post)
                }
            }
            
            else if type == "" && category != "" && query == ""{
                let snapshot = try await db.collection("\(university)_Posts").whereField("category", isEqualTo: category).order(by: "postedAt", descending: true).start(afterDocument: search_last!).limit(to: 10).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                } else {
                    return
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    temp.append(post)
                }
            }
            
            else if type != "" && category == "" && query == ""{
                let snapshot = try await db.collection("\(university)_Posts").whereField("type", isEqualTo: type).order(by: "postedAt", descending: true).start(afterDocument: search_last!).limit(to: 10).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                } else {
                    return
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    temp.append(post)
                }
            }
            
            else if type != "" && category == ""{
                let snapshot = try await db.collection("\(university)_Posts").whereField("keywordsForLookup", arrayContains: query).whereField("type", isEqualTo: type).order(by: "postedAt", descending: true).start(afterDocument: search_last!).limit(to: 10).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                } else {
                    return
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    temp.append(post)
                }
            }
            
            else if type == "" && category != ""{
                let snapshot = try await db.collection("\(university)_Posts").whereField("keywordsForLookup", arrayContains: query).whereField("category", isEqualTo: category).order(by: "postedAt", descending: true).start(afterDocument: search_last!).limit(to: 10).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                } else {
                    return
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    temp.append(post)
                }
            }
            
            else if type != "" && category != ""{
                let snapshot = try await db.collection("\(university)_Posts").whereField("keywordsForLookup", arrayContains: query).whereField("type", isEqualTo: type).whereField("category", isEqualTo: category).order(by: "postedAt", descending: true).start(afterDocument: search_last!).limit(to: 10).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                } else {
                    return
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    temp.append(post)
                }
            }
            
            
            else {
                let snapshot = try await db.collection("\(university)_Posts").whereField("keywordsForLookup", arrayContains: query).order(by: "postedAt", descending: true).start(afterDocument: search_last!).limit(to: 10).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                } else {
                    return
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    temp.append(post)
                }
            }
            
            search_results.append(contentsOf: temp)
            
        }
        catch {
            print("error updating search results")
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
