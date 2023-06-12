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
import FirebaseFunctions

@MainActor
class FirestoreManager: ObservableObject {
    
    @AppStorage("university") var university: String = ""
    @AppStorage("username") var username_system: String = ""
    @AppStorage("email") var email_system: String = ""
    @AppStorage("signedin") var isSignedIn: Bool = false
    @AppStorage("termsagreed") var agreedToTerms: Bool = false
    @Environment(\.dismiss) var dismiss
    
    @Published var scroll_up : Bool = false
    
    @Published var listings: [PostModel] = []
    @Published var listing_last : QueryDocumentSnapshot? = nil
    @Published var listings_loading: Bool = false
    @Published var listings_refresh: Bool = true
    @Published var listings_error: Bool = false
    
    @Published var requests: [PostModel] = []
    @Published var requests_last : QueryDocumentSnapshot? = nil
    @Published var requests_loading: Bool = false
    @Published var requests_refresh: Bool = true
    @Published var requests_error: Bool = false
    
    @Published var saved_posts: [PostModel] = []
    @Published var saved_last: QueryDocumentSnapshot? = nil
    @Published var saved_refresh: Bool = false
    @Published var saved_loading: Bool = false
    @Published var saved_error: Bool = false
    
    @Published var my_posts: [PostModel] = []
    @Published var user_last: QueryDocumentSnapshot? = nil
    @Published var user_refresh: Bool = false
    @Published var my_posts_loading: Bool = false
    @Published var my_posts_error: Bool = false
    
    @Published var user_temp_posts: [PostModel] = []
    @Published var user_temp_last: QueryDocumentSnapshot? = nil
    @Published var user_temp_refresh: Bool = false
    @Published var user_temp_posts_loading: Bool = false
    @Published var user_temp_posts_error: Bool = false
    
//    @Published var listings_filtered : [PostModel] = []
//    @Published var listings_filtered_last : QueryDocumentSnapshot? = nil
    @Published var listings_filtered_loading: Bool = false
    @Published var listings_filtered_refresh: Bool = true
    @Published var listings_filtered_error: Bool = false
//
//    @Published var requests_filtered: [PostModel] = []
//    @Published var requests_filtered_last : QueryDocumentSnapshot? = nil
    
    @Published var requests_filtered_loading: Bool = false
    @Published var requests_filtered_refresh: Bool = true
    @Published var requests_filtered_error: Bool = false
//
    @Published var search_results: [PostModel] = []
    @Published var search_last: QueryDocumentSnapshot? = nil
    @Published var search_results_loading: Bool = false
    @Published var search_error: Bool = false
    
    @Published var search_results_previous: [PostModel] = []
    @Published var search_last_previous: QueryDocumentSnapshot? = nil
    
    @Published var listings_tab: Bool = false
    @Published var requests_tab: Bool = false
    
    @Published var post_count: Int = 0
    @Published var saved_count: Int = 0
    @Published var metrics_loading: Bool = false
    
    @Published var postTemp_count: Int = 0
    @Published var metricsTemp_loading: Bool = false
    
    
    
    private var db = Firestore.firestore()
    private var storage = Storage.storage()
    
    init(){
        Task {
            if isSignedIn && agreedToTerms{
                await getListings()
                await getRequests()
                await getSaved()
                await userPosts()
                await getMetrics()
            }
        }
    }
    
    /*
     Function for verifying the domain found in email given by user
     */
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
    
    
    /*
     Function for checking whether user's username is in use or not
     */
    func verifyUsername(username: String, usernameInUse: Binding<Bool>, cannot_verify: Binding<Bool>) async {
        var not_found: Bool = false
        
        do {
            let snapshot = try await db.collection("Usernames").whereField("username", isEqualTo: username).getDocuments()
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
    
    /*
     Function for uploading images to firebase storage
     */
    func uploadImages(images: [UIImage]) async -> [String]{
        
//        var result : [String : [String]]
        var urls : [String] = []
//        var ids : [String] = []
        
        var error_found = false
        let storageRef = storage.reference()
        
        if !images.isEmpty{
            for image in images {
                let imageData = image.jpegData(compressionQuality: 0.4)
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
    
    /*
     Function for converting post model to dictionary
     */
    func convertPostModelToDictionary(post: PostModel) -> [String : Any?] {
        var result : [String : Any?] = [:]
        result["id"] = post.id
        result["title"] = post.title
        result["userID"] = post.userID
        result["username"] = post.username
        result["description"] = post.description
        result["postedAt"] = post.postedAt
        result["condition"] = post.condition
        result["category"] = post.category
        result["price"] = post.price
        result["imageURLs"] = post.imageURLs
        result["channel"] = post.channel
        result["savers"] = post.savers
        result["type"] = post.type
        result["keywordsForLookup"] = post.keywordsForLookup
        result["reporters"] = post.reporters
        
        return result
    }
    
    /*
     Function for converting dictionary to PostModel
     */
    func convertDictionaryToPostModel(dictionary : [String : Any]) -> PostModel{
        var result = PostModel(
            title: dictionary["id"] as? String ?? "",
            userID: dictionary["userID"] as? String ?? "",
            username: dictionary["username"] as? String ?? "",
            description: dictionary["description"] as? String ?? "",
            condition: dictionary["condition"] as? String ?? "",
            category: dictionary["category"]  as? String ?? "",
            price: dictionary["price"] as? String ?? "",
            imageURLs: dictionary["imageURLs"] as? [String] ?? [],
            channel: dictionary["channel"] as? String ?? "",
            savers: dictionary["savers"] as? [String] ?? [],
            type: dictionary["type"] as? String ?? "",
            keywordsForLookup: dictionary["keywordsForLookup"] as? [String] ?? [],
            reporters: dictionary["reporters"] as? [String] ?? [])
        
        if dictionary["borrow"] != nil {
            result.borrow = dictionary["borrow"] as? Bool ?? false
        }
        
        return result
    }
    
    func getMetrics() async {
        metrics_loading = true
        let cur_id = Auth.auth().currentUser?.uid
        
        if cur_id != nil {
           
            
            do {
                let result = try await Functions.functions().httpsCallable("getMetrics").call(["cur_id": cur_id!, "university": university])
                let data = result.data as? [String: Any] ?? [:]
                post_count = data["post_count"] as? Int ?? 0
                saved_count = data["saved_count"] as? Int ?? 0
                metrics_loading = false
              
            }
            catch{
                print("unable to retrieve metrics")
                metrics_loading = false
            }
            
        }
        
    }
    
    func getUserMetrics(cur_id: String) async {
        metricsTemp_loading = true
        if cur_id.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "") != ""{
            do {
                let result = try await Functions.functions().httpsCallable("getMetrics").call(["cur_id": cur_id, "university": university])
                let data = result.data as? [String: Any] ?? [:]
                postTemp_count = data["post_count"] as? Int ?? 0
                metricsTemp_loading = false
            }
            catch{
                print("unable to retrieve metrics")
                metricsTemp_loading = false
            }
            
        }
    }
    
    
    /*
     Function for making a post and storing it on firestore database
     */
    func makePost(post: PostModel, images: [UIImage], post_created: Binding<Bool>) async -> Bool {
        
        var urls : [String] = []
        if !images.isEmpty{
            urls = await uploadImages(images: images)
        }

        if urls == ["error"]{
            return false
        }
        
        var post_temp = post
        
        post_temp.imageURLs.append(contentsOf: urls)
        
        let cur_id = Auth.auth().currentUser?.uid
        
        if cur_id == nil{
            return false
        }
        
        post_temp.userID = cur_id!
        post_temp.username = username_system
        post_temp.channel = university
        
        let batch = db.batch()
    
        do {
            
            let postRef =  db.collection("Universities").document("\(university)").collection("Posts").document(post.id)
            let userRef =  db.collection("Users").document(cur_id!)
            
            try batch.setData(from: post_temp, forDocument: postRef)
            batch.updateData(["post_count": FieldValue.increment(Int64(1))], forDocument: userRef)
            try await batch.commit()
            
            print("Post completed")
            post_created.wrappedValue = true
            await getMetrics()
            print(post_created.wrappedValue)
            return true
                
         }
           catch {
//               completion(uploadError("Error uploading post"))
               return false
           }
        
        
    
        
    }
    
    func editPost(post: Binding<PostModel>, images: [UIImage]) async -> Bool {
        var urls : [String] = []
        if !images.isEmpty{
            urls = await uploadImages(images: images)
        }

        if urls == ["error"]{
            return false
        }
        
        var post_temp = post.wrappedValue
        
        post_temp.imageURLs.append(contentsOf: urls)
        
        let postRef = db.collection("Universities").document("\(university)").collection("Posts").document(post.id)
        
        let batch = db.batch()
        
        do {
           try batch.setData(from: post_temp, forDocument: postRef)
           try await batch.commit()
            post.wrappedValue = post_temp
           return true
        }
        
        catch {
            return false
        }
        
    }
    
    
    
    /*
     Function for deleting post from firebase storage
     */
    func deletePost(post: PostModel, deleted : Binding<Bool>, error_alert: Binding<Bool>) async -> Bool {
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
        
        let batch = db.batch()
        
        let cur_id = Auth.auth().currentUser?.uid
        
        if cur_id == nil {
            return false
        }
        
        do {
            let postRef =  db.collection("Universities").document("\(university)").collection("Posts").document(post.id)
            let userRef =  db.collection("Users").document(cur_id!)
            batch.updateData(["post_count": FieldValue.increment(Int64(-1))], forDocument: userRef)
            batch.deleteDocument(postRef)
            try await batch.commit()
            await getMetrics()
            return true
        }
        catch {
            return false
//            error_alert.wrappedValue = true
        }
    }
    
    /*
     Function for reporting posts
     */
    func reportPost(report: ReportModel, post: PostModel) async -> Bool {
        let postRef = db.collection("Universities").document("\(university)").collection("Posts").document(post.id)
        
        let userId = Auth.auth().currentUser?.uid
        
        if userId == nil{
            return false
        }
        
        do {
            try db.collection("Universities").document("\(university)").collection("Post-Reports").document(report.id).setData(from: report)
            try await postRef.updateData(["reporters": FieldValue.arrayUnion([userId!])])
            return true
        }
        catch {
            print("error reporting post")
            return false
        }
    }
    
    /*
     Function for saving posts to database
     */
    func savePost(post: PostModel) async -> Bool {
        
        let postRef = db.collection("Universities").document("\(university)").collection("Posts").document(post.id)
        
        let userId = Auth.auth().currentUser?.uid
        
        if userId == nil{
            return false
        }
        
        let userRef =  db.collection("Users").document(userId!)
        
        let batch = db.batch()
        
        do {
            
            batch.updateData(["saved_count": FieldValue.increment(Int64(1))], forDocument: userRef)
            batch.updateData(["savers": FieldValue.arrayUnion([userId!])], forDocument: postRef)
            try await batch.commit()
            withAnimation {
                saved_posts.insert(post, at: 0)
            }
            await getMetrics()
            return true
            
        }
        catch {
            print("error saving post")
            return false
        }
    }
    
    /*
     Function for unsaving posts from the database
     */
    func unsavePost(post: PostModel) async -> Bool {
        let postRef = db.collection("Universities").document("\(university)").collection("Posts").document(post.id)
       
        let userId = Auth.auth().currentUser?.uid
        
        if userId == nil{
            return false
        }
        
        let userRef =  db.collection("Users").document(userId!)
        
        let batch = db.batch()
        
        do {
            if saved_count != 0{
                batch.updateData(["saved_count": FieldValue.increment(Int64(-1))], forDocument: userRef)
            }
    
            batch.updateData(["savers": FieldValue.arrayRemove([userId!])], forDocument: postRef)
            
            try await batch.commit()
            await getMetrics()
            return true
        }
        catch {
            return false
        }
    }
    
    func confirmPost(post: PostModel) async -> Bool {
        let postRef =  db.collection("Universities").document("\(university)").collection("Posts").document(post.id)
        do {
            if post.type == "Listing"{
                try await postRef.updateData(["price" : "Sold"])
            } else {
                try await postRef.updateData(["price" : "Satisfied"])
            }
            return true
        }
        catch {
            return false
        }
    }
    
    
    /*
     Function for converting queryDocumentSnapshots to posts
     */
    func convertToPost(doc : QueryDocumentSnapshot) -> PostModel {
        let data = doc.data()
        var result = PostModel(id: data["id"] as? String ?? "",
                  title: data["title"] as? String ?? "",
                  userID: data["userID"] as? String ?? "",
                  username: data["username"] as? String ?? "",
                  description: data["description"] as? String ?? "",
                  postedAt: data["postedAt"] as? Timestamp ?? Timestamp(date: Date.now),
                  condition: data["condition"] as? String ?? "",
                  category: data["category"] as? String ?? "",
                  price: data["price"] as? String ?? "",
                  imageURLs: data["imageURLs"] as? [String] ?? [],
                  channel: data["channel"] as? String ?? "",
                  savers: data["savers"] as? [String] ?? [],
                  type: data["type"] as? String ?? "",
                  keywordsForLookup: data["keywordsForLookup"] as? [String] ?? [],
                  reporters: data["reporters"] as? [String] ?? [])
        
        if data["borrow"] != nil {
            result.borrow = data["borrow"] as? Bool ?? false
        }
        
        return result
    }
    
    func getPost(postID: String) async -> PostModel? {
        
        var post : PostModel? = nil
        
        do {
            let postRef = db.collection("Universities").document("\(university)").collection("Posts").document(postID)
            let document = try await postRef.getDocument()
            let data = document.data()
            var post_temp = PostModel(id: data?["id"] as? String ?? "",
                                  title: data?["title"] as? String ?? "",
                                  userID: data?["userID"] as? String ?? "",
                                  username: data?["username"] as? String ?? "",
                                  description: data?["description"] as? String ?? "",
                                  postedAt: data?["postedAt"] as? Timestamp ?? Timestamp(date: Date.now),
                                  condition: data?["condition"] as? String ?? "",
                                  category: data?["category"] as? String ?? "",
                                  price: data?["price"] as? String ?? "",
                                  imageURLs: data?["imageURLs"] as? [String] ?? [],
                                  channel: data?["channel"] as? String ?? "",
                                  savers: data?["savers"] as? [String] ?? [],
                                  type: data?["type"] as? String ?? "",
                                  keywordsForLookup: data?["keywordsForLookup"] as? [String] ?? [],
                                  reporters: data?["reporters"] as? [String] ?? [])
            
            if data?["borrow"] != nil {
                post_temp.borrow = data?["borrow"] as? Bool ?? false
            }
            post = post_temp
            return post
            
        }
        catch {
            return nil
        }
    }
    

    /*
     Function to retrieve listings from specific university/channel from database
     */
    func getListings() async {
        
        let prior_list = listings
        
        do {
            listings_loading = true
//            listings.removeAll()

            var temp: [PostModel] = []
            let snapshot = try await db.collection("Universities").document("\(university)").collection("Posts").whereField("type", isEqualTo: "Listing").order(by: "postedAt", descending: true).limit(to: 15).getDocuments()
            let documents = snapshot.documents
            if !documents.isEmpty{
                listing_last = documents.last!
            }
            for document in documents{
                let post = convertToPost(doc: document)
                temp.append(post)
            }

            withAnimation{
                listings = temp
                listings_loading = false
                listings_error = false
            }
        }
        catch {
            listings = prior_list
            listings_loading = false
            listings_error = true
            print("error")
        }
    }

    /*
     Function to update listings upon scrolling down to end of list
     */
    func updateListings() async {
        do {
            var temp: [PostModel] = []
            if listing_last == nil{
                return
            }
            let snapshot = try await db.collection("Universities").document("\(university)").collection("Posts").whereField("type", isEqualTo: "Listing").order(by: "postedAt", descending: true).start(afterDocument: listing_last!).limit(to: 15).getDocuments()

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
            withAnimation{
                listings.append(contentsOf: temp)
            }
           
        }

        catch {
            print("error updating listings")
        }

    }
    
    func getListingsFiltered(category: String) async {
        do {
            listings_filtered_loading = true
            var temp: [PostModel] = []
            let snapshot = try await db.collection("Universities").document("\(university)").collection("Posts").whereField("type", isEqualTo: "Listing").whereField("category", isEqualTo: category).order(by: "postedAt", descending: true).limit(to: 15).getDocuments()
            let documents = snapshot.documents
            if !documents.isEmpty{
                listing_last = documents.last!
//                listings_filtered_last = documents.last!
            }
            for document in documents{
                let post = convertToPost(doc: document)
                temp.append(post)
            }
            withAnimation{
                listings = temp
//                listings_filtered = temp
                listings_filtered_loading = false
                listings_filtered_error = false
            }
          
        }
        
        catch {
            listings_filtered_loading = false
            listings_filtered_error = true
            print("Error getting listings")
        }
    }
    
    func updateListingsFiltered(category: String) async {
        if listing_last == nil {
            return
        }
//        if listings_filtered_last == nil {
//            return
//        }
        
        do {
            var temp: [PostModel] = []
//            let snapshot = try await db.collection("Universities").document("\(university)").collection("Posts").whereField("type", isEqualTo: "Listing").whereField("category", isEqualTo: category).order(by: "postedAt", descending: true).start(afterDocument: listings_filtered_last!).limit(to: 15).getDocuments()
                let snapshot = try await
                    db.collection("Universities")
                    .document("\(university)")
                    .collection("Posts")
                    .whereField("type", isEqualTo: "Listing")
                    .whereField("category", isEqualTo: category)
                    .order(by: "postedAt", descending: true)
                    .start(afterDocument: listing_last!)
                    .limit(to: 15).getDocuments()
            let documents = snapshot.documents
            if !documents.isEmpty{
                listing_last = documents.last!
//                listings_filtered_last = documents.last!
            } else {
                return
            }
            for document in documents{
                let post = convertToPost(doc: document)
                temp.append(post)
            }
            print(temp.count)
            
            withAnimation{
                listings.append(contentsOf: temp)
//                listings_filtered.append(contentsOf: temp)
            }
            
            
        }
        catch {
            print("error updating listings")
        }
    }
    

    /*
     Function to retrieve requests from specific university/channel from database
     */
    func getRequests() async {
        
        let prior_list = requests
        
        do {
            requests_loading = true
//            requests.removeAll()
            var temp: [PostModel] = []
            let snapshot = try await db.collection("Universities").document("\(university)").collection("Posts").whereField("type", isEqualTo: "Request").order(by: "postedAt", descending: true).limit(to: 15).getDocuments()
            let documents = snapshot.documents
            if !documents.isEmpty{
                requests_last = documents.last!
            }
            for document in documents{
                let post = convertToPost(doc: document)
                temp.append(post)
            }
            withAnimation{
                requests = temp
                requests_loading = false
                requests_error = false
            }
          

        }
        catch {
            requests = prior_list
            requests_loading = false
            requests_error = true
            print("error")
        }
    }
    
    /*
     Function to update requests upon scrolling down to end of list
     */
    func updateRequests() async {
        do {
            var temp: [PostModel] = []
            if requests_last == nil{
                return
            }
            let snapshot = try await db.collection("Universities").document("\(university)").collection("Posts").whereField("type", isEqualTo: "Request").order(by: "postedAt", descending: true).start(afterDocument: requests_last!).limit(to: 15).getDocuments()
            
            let documents = snapshot.documents
            if !documents.isEmpty {
                requests_last = documents.last!
            } else {
                return
            }
            for document in documents {
                let post = convertToPost(doc: document)
                temp.append(post)
            }
            withAnimation {
                requests.append(contentsOf: temp)
            }
        }
        
        catch {
            print("error updating requests")
        }
        
    }
    
    func  getRequestsFiltered(category: String) async {
        do {
            requests_filtered_loading = true
            var temp: [PostModel] = []
            let snapshot = try await db.collection("Universities").document("\(university)").collection("Posts").whereField("type", isEqualTo: "Request").whereField("category", isEqualTo: category).order(by: "postedAt", descending: true).limit(to: 15).getDocuments()
            let documents = snapshot.documents
            if !documents.isEmpty{
                requests_last = documents.last!
//                requests_filtered_last = documents.last!
            }
            for document in documents{
                let post = convertToPost(doc: document)
                temp.append(post)
            }
            
            withAnimation{
                requests = temp
//                requests_filtered = temp
                requests_filtered_loading = false
                requests_filtered_error = false
            }
           
        }
        
        catch {
            requests_filtered_loading = false
            requests_filtered_error = true
            print("Error getting requests")
        }
    }
    
    func updateRequestsFiltered(category: String) async {
//        if requests_filtered_last == nil {
//            return
//        }
        if requests_last == nil {
            return
        }
        
        do {
            var temp: [PostModel] = []
//            let snapshot = try await db.collection("Universities").document("\(university)").collection("Posts").whereField("type", isEqualTo: "Request").whereField("category", isEqualTo: category).order(by: "postedAt", descending: true).start(afterDocument: requests_filtered_last!).limit(to: 15).getDocuments()
            let snapshot = try await
                db.collection("Universities")
                .document("\(university)")
                .collection("Posts")
                .whereField("type", isEqualTo: "Request")
                .whereField("category", isEqualTo: category)
                .order(by: "postedAt", descending: true)
                .start(afterDocument: requests_last!)
                .limit(to: 15).getDocuments()
            let documents = snapshot.documents
            if !documents.isEmpty{
//                requests_filtered_last = documents.last!
                requests_last = documents.last!
            } else {
                return
            }
            for document in documents{
                let post = convertToPost(doc: document)
                temp.append(post)
            }
            withAnimation{
                requests.append(contentsOf: temp)
//                requests_filtered.append(contentsOf: temp)
            }
        }
        catch {
            print("error updating requests")
        }
    }
    
    /*
     Function to retrieve the user's saved posts from the database
     */
    func getSaved() async {
        
        let userId = Auth.auth().currentUser?.uid
        
        do {
            saved_loading = true
            var temp: [PostModel] = []
            
            if userId == nil{
                return
            }
            
            let snapshot = try await db.collection("Universities").document("\(university)").collection("Posts").whereField("savers", arrayContains: userId!).order(by: "postedAt", descending: true).limit(to: 15).getDocuments()
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
            saved_error = false
            
        }
        catch {
            saved_loading = false
            saved_error = true
            print("error")
        }
    }
    
    /*
     Function to update the user's saved posts upon scrolling to the bottom
     */
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
            
            let snapshot = try await db.collection("Universities").document("\(university)").collection("Posts").whereField("savers", arrayContains: userId!).order(by: "postedAt", descending: true).start(afterDocument: saved_last!).limit(to: 15).getDocuments()
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
    
    /*
     Function to retrieve the user's posts from the database
     */
    func userPosts() async {
        
        let userId = Auth.auth().currentUser?.uid
        
        do {
            my_posts_loading = true
            var temp: [PostModel] = []
            
            
            if userId == nil{
                return
            }
            
            
            let snapshot = try await db.collection("Universities").document("\(university)").collection("Posts").whereField("userID", isEqualTo:userId!).order(by: "postedAt", descending: true).limit(to: 15).getDocuments()
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
            my_posts_error = false
            
        }
        catch {
            my_posts_loading = false
            my_posts_error = true
            print("error")
        }
    }
    
    /*
     Function to update the user's posts upon scrolling to the bottom of the feed
     */
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
            
            let snapshot = try await db.collection("Universities").document("\(university)").collection("Posts").whereField("userID", isEqualTo:userId!).order(by: "postedAt", descending: true).start(afterDocument: user_last!).limit(to: 15).getDocuments()
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
    
    func getUserTempPosts(userId: String) async {
        
        if userId.replacingOccurrences(of: " ", with: "") == ""{
            return
        }
        
        do {
            user_temp_posts_loading = true
            var temp: [PostModel] = []
            
            let snapshot = try await db.collection("Universities").document("\(university)").collection("Posts").whereField("userID", isEqualTo:userId).order(by: "postedAt", descending: true).limit(to: 15).getDocuments()
            let documents = snapshot.documents
            if !documents.isEmpty{
               user_temp_last = documents.last!
            }
            for document in documents{
                let post = convertToPost(doc: document)
                temp.append(post)
            }
            user_temp_posts = temp
            user_temp_posts_loading = false
            user_temp_posts_error = false
            
        }
        catch {
            user_temp_posts_loading = false
            user_temp_posts_error = true
            print("error")
        }
        
    }
    
    func updateUserTempPosts(userId: String) async {
        
        if userId.replacingOccurrences(of: " ", with: "") == ""{
            return
        }
        
        do {
            var temp: [PostModel] = []
            
            if user_temp_last == nil{
                return
            } else {
                let snapshot = try await db.collection("Universities").document("\(university)").collection("Posts").whereField("userID", isEqualTo:userId).order(by: "postedAt", descending: true).start(afterDocument: user_temp_last!).limit(to: 15).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                   user_temp_last = documents.last!
                } else {
                    return
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    if post.price != "Sold" && post.price != "Satisfied" {
                        temp.append(post)
                    }
                }
                user_temp_posts.append(contentsOf:temp)
                
            }
          
            
        }
        catch {
            print("error updating user posts")
        }
    }
    
    /*
     Function to search for posts
     */
    func searchPosts(query : String, type: String, category: String) async {
        
       
        do {
            search_results_loading = true
            var temp: [PostModel] = []
            
            if type != "" && category != "" && query == ""{
                let snapshot = try await db.collection("Universities")
                    .document("\(university)")
                    .collection("Posts")
                    .whereField("type", isEqualTo: type)
                    .whereField("category", isEqualTo: category)
                    .order(by: "postedAt", descending: true)
                    .limit(to: 15).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    if post.price != "Sold" && post.price != "Satisfied" {
                        temp.append(post)
                    }
                }
            }
            
            else if type == "" && category != "" && query == ""{
                let snapshot = try await db.collection("Universities")
                    .document("\(university)")
                    .collection("Posts")
                    .whereField("category", isEqualTo: category)
                    .order(by: "postedAt", descending: true)
                    .limit(to: 15).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    if post.price != "Sold" && post.price != "Satisfied" {
                        temp.append(post)
                    }
                }
            }
            
            else if type != "" && category == "" && query == ""{
                let snapshot = try await db.collection("Universities")
                    .document("\(university)")
                    .collection("Posts")
                    .whereField("type", isEqualTo: type)
                    .order(by: "postedAt", descending: true)
                    .limit(to: 15).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    if post.price != "Sold" && post.price != "Satisfied" {
                        temp.append(post)
                    }
                }
            }
            
            else if type != "" && category == ""{
                let snapshot = try await db.collection("Universities")
                    .document("\(university)")
                    .collection("Posts")
                    .whereField("keywordsForLookup", arrayContains: query)
                    .whereField("type", isEqualTo: type)
                    .order(by: "postedAt", descending: true)
                    .limit(to: 15).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    if post.price != "Sold" && post.price != "Satisfied" {
                        temp.append(post)
                    }
                }
            }
            
            else if type == "" && category != ""{
                let snapshot = try await db.collection("Universities")
                    .document("\(university)")
                    .collection("Posts")
                    .whereField("keywordsForLookup", arrayContains: query)
                    .whereField("category", isEqualTo: category)
                    .order(by: "postedAt", descending: true)
                    .limit(to: 15).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    if post.price != "Sold" && post.price != "Satisfied" {
                        temp.append(post)
                    }
                }
            }
            
            else if type != "" && category != ""{
                let snapshot = try await db.collection("Universities")
                    .document("\(university)")
                    .collection("Posts")
                    .whereField("keywordsForLookup", arrayContains: query)
                    .whereField("type", isEqualTo: type)
                    .whereField("category", isEqualTo: category)
                    .order(by: "postedAt", descending: true)
                    .limit(to: 15).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    if post.price != "Sold" && post.price != "Satisfied" {
                        temp.append(post)
                    }
                }
            }
            
            
            else {
                let snapshot = try await db.collection("Universities")
                    .document("\(university)")
                    .collection("Posts")
                    .whereField("keywordsForLookup", arrayContains: query)
                    .order(by: "postedAt", descending: true).limit(to: 15).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    if post.price != "Sold" && post.price != "Satisfied" {
                        temp.append(post)
                    }
                }
            }
            
            search_results = temp
            search_results_loading = false
            search_error = false
            
        }
        catch {
            search_results_loading = false
            search_error = true
            print("error")
        }

    }
    
    /*
     Function to update the search results upon scrolling to the bottom of the feed
     */
    func updateSearch(query : String, type: String, category: String) async {
        
        if search_last == nil {
            return
        }
        
        do {
            var temp: [PostModel] = []
            
            if type != "" && category != "" && query == ""{
                let snapshot = try await db.collection("Universities")
                    .document("\(university)")
                    .collection("Posts")
                    .whereField("type", isEqualTo: type)
                    .whereField("category", isEqualTo: category)
                    .order(by: "postedAt", descending: true)
                    .start(afterDocument: search_last!).limit(to: 15)
                    .getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                } else {
                    return
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    if post.price != "Sold" && post.price != "Satisfied" {
                        temp.append(post)
                    }
                }
            }
            
            else if type == "" && category != "" && query == ""{
                let snapshot = try await db.collection("Universities")
                    .document("\(university)")
                    .collection("Posts")
                    .whereField("category", isEqualTo: category)
                    .order(by: "postedAt", descending: true)
                    .start(afterDocument: search_last!)
                    .limit(to: 15).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                } else {
                    return
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    if post.price != "Sold" && post.price != "Satisfied" {
                        temp.append(post)
                    }
                }
            }
            
            else if type != "" && category == "" && query == ""{
                let snapshot = try await db.collection("Universities")
                    .document("\(university)")
                    .collection("Posts")
                    .whereField("type", isEqualTo: type)
                    .order(by: "postedAt", descending: true)
                    .start(afterDocument: search_last!).limit(to: 15).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                } else {
                    return
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    if post.price != "Sold" && post.price != "Satisfied" {
                        temp.append(post)
                    }
                }
            }
            
            else if type != "" && category == ""{
                let snapshot = try await db.collection("Universities")
                    .document("\(university)")
                    .collection("Posts")
                    .whereField("keywordsForLookup", arrayContains: query)
                    .whereField("type", isEqualTo: type)
                    .order(by: "postedAt", descending: true)
                    .start(afterDocument: search_last!).limit(to: 15).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                } else {
                    return
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    if post.price != "Sold" && post.price != "Satisfied" {
                        temp.append(post)
                    }
                }
            }
            
            else if type == "" && category != ""{
                let snapshot = try await db.collection("Universities")
                    .document("\(university)")
                    .collection("Posts")
                    .whereField("keywordsForLookup", arrayContains: query)
                    .whereField("category", isEqualTo: category)
                    .order(by: "postedAt", descending: true)
                    .start(afterDocument: search_last!).limit(to: 15).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                } else {
                    return
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    if post.price != "Sold" && post.price != "Satisfied" {
                        temp.append(post)
                    }
                }
            }
            
            else if type != "" && category != ""{
                let snapshot = try await db.collection("Universities")
                    .document("\(university)")
                    .collection("Posts")
                    .whereField("keywordsForLookup", arrayContains: query)
                    .whereField("type", isEqualTo: type)
                    .whereField("category", isEqualTo: category)
                    .order(by: "postedAt", descending: true)
                    .start(afterDocument: search_last!)
                    .limit(to: 15).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                } else {
                    return
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    if post.price != "Sold" && post.price != "Satisfied" {
                        temp.append(post)
                    }
                }
            }
            
            
            else {
                let snapshot = try await db.collection("Universities")
                    .document("\(university)")
                    .collection("Posts")
                    .whereField("keywordsForLookup", arrayContains: query)
                    .order(by: "postedAt", descending: true)
                    .start(afterDocument: search_last!)
                    .limit(to: 15).getDocuments()
                let documents = snapshot.documents
                if !documents.isEmpty{
                    search_last = documents.last!
                } else {
                    return
                }
                for document in documents{
                    let post = convertToPost(doc: document)
                    if post.price != "Sold" && post.price != "Satisfied" {
                        temp.append(post)
                    }
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
