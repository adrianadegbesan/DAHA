//
//  BookmarkButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/29/23.
//

import SwiftUI
import FirebaseAuth

struct BookmarkButton: View {
    
    @Binding var post: PostModel
    @Binding var saved: Bool
    @State private var save_alert: Bool = false
    @State private var unsave_alert: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var firestoreManager : FirestoreManager
    @State private var updating: Bool = false
//    @State var time = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        Button(action: {
            SoftFeedback()
            updating = true
            if saved {

                
//                if !updating {
                    Task{
                        let result = await firestoreManager.unsavePost(post: post)
                        if !result {
                            unsave_alert = true
                        }
//                        updating = false
                        
                    }
//                    firestoreManager.saved_refresh = true
                    withAnimation {
//                        if let index = firestoreManager.saved_posts.firstIndex(where: { $0.id == post.id }), index < firestoreManager.saved_posts.count {
//                            withAnimation {
//                                _ = firestoreManager.saved_posts.remove(at: index)
//                            }
//                        }
                        
                        let id = Auth.auth().currentUser?.uid
                        if let id = id{
                            if let index = post.savers.firstIndex(of: id){
                                if index < post.savers.count {
                                    post.savers.remove(at: index)
                                }

                            }
                            
                            if let indexPost = firestoreManager.saved_posts.firstIndex(where: {$0.id == post.id}){
                                if firestoreManager.saved_posts[indexPost].savers.contains(id){
                                    if let ind1 = firestoreManager.saved_posts[indexPost].savers.firstIndex(of: id){
                                        if ind1 < firestoreManager.saved_posts[indexPost].savers.count{
                                            firestoreManager.saved_posts[indexPost].savers.remove(at: ind1)
                                        }
                                    }
                                }
                            }
                            
//
                            if post.type == "Listing"{

                                if let index_l = firestoreManager.listings.firstIndex(where: {$0.id == post.id}){

                                    if firestoreManager.listings[index_l].savers.contains(id){
                                        if let ind1 = firestoreManager.listings[index_l].savers.firstIndex(of: id){
                                            if ind1 < firestoreManager.listings[index_l].savers.count{
                                                firestoreManager.listings[index_l].savers.remove(at: ind1)
                                            }
                                        }
                                    }
                                }
                            } else if post.type == "Request"{
                                if let index_l = firestoreManager.requests.firstIndex(where: {$0.id == post.id}){

                                    if firestoreManager.requests[index_l].savers.contains(id){
                                        if let ind1 = firestoreManager.requests[index_l].savers.firstIndex(of: id){
                                            if ind1 < firestoreManager.requests[index_l].savers.count {
                                                firestoreManager.requests[index_l].savers.remove(at: ind1)
                                            }
                                        }
                                    }

                                }
                            }
                        }
                        saved.toggle()
                    }
//                }
               
            } else {
                
//                if !updating{
                    Task{
                        let result = await firestoreManager.savePost(post: post)
                        if !result {
                            save_alert = true
                        }
//                        updating = false
                    }
//                    firestoreManager.saved_refresh = true
                    withAnimation{
                        let id = Auth.auth().currentUser?.uid
                        if id != nil && !post.savers.contains(id!){
                            post.savers.append(id!)
                        }
                        saved.toggle()
                    }
//                }
            }
            
        }){
            if saved{
                Image(systemName: "bookmark.fill")
                    .minimumScaleFactor(0.05)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color(hex: deepBlue))
            } else {
                Image(systemName: "bookmark")
                    .minimumScaleFactor(0.05)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            }
        }
        .buttonStyle(.plain)
        .onAppear {

            let cur_id = Auth.auth().currentUser?.uid
            if cur_id != nil{
                if post.savers.contains(cur_id!){
                    saved = true
                }
            } else {
                saved = false
            }
        }
        .onChange(of: post.savers){ value in
            let cur_id = Auth.auth().currentUser?.uid
            if cur_id != nil{
                if !post.savers.contains(cur_id!){
                    saved = false
                } else {
                    saved = true
                }
            }
        }
        .alert("Error Saving Post", isPresented: $save_alert, actions: {}, message: {Text("Please check your network connection and try again later")})
        .alert("Error Unsaving Post", isPresented: $unsave_alert, actions: {}, message: {Text("Please check your network connection and try again later")})
        
    }
}

struct BookmarkButton_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "", keywordsForLookup: [], reporters: [])
        BookmarkButton(post: .constant(post), saved: .constant(false))
    }
}
