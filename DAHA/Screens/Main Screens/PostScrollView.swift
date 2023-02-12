//
//  PostScrollView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/11/23.
//

import SwiftUI

struct PostScrollView: View {
    
    @Binding var posts: [PostModel]
    @Binding var loading: Bool
    @State var screen: String
    @Binding var query: String
    @Binding var type: String
    @Binding var category: String
    @EnvironmentObject var firestoreManager : FirestoreManager
    @EnvironmentObject var network: Network
    
    var body: some View {
        ScrollView{
            
            if !network.connected {
                Text("Please check your internet connection")
                    .titleText()
            }
            else if loading {
                ProgressView()
            } else if posts.isEmpty{
                ProgressView()
            } else {
                ForEach(posts) { post in
                    if post.userID == firestoreManager.userId{
                        PostView(post: post, owner: true)
                    } else {
                        PostView(post: post, owner: false)
                    }
                }
            }
            
        }
        .refreshable {
            if screen == "Listings"{
                Task {
                    await firestoreManager.getListings()
                }
            }
            
            if screen == "Requests" {
                Task {
                    await firestoreManager.getRequests()
                }
            }
            
            if screen == "Saved" {
                Task {
                    await firestoreManager.getSaved()
                }
            }
            
            if screen == "User" {
                Task {
                    await firestoreManager.userPosts()
                }
            }
            
            if screen == "Search" {
                Task {
                    await firestoreManager.searchPosts(query: query, type: type, category: category)
                }
            }
        }
        .onAppear{
            network.checkConnection()
        }
    }
    
    struct PostScrollView_Previews: PreviewProvider {
        static var previews: some View {
            let posts : [PostModel] = []
            
            PostScrollView(posts: .constant(posts), loading: .constant(false), screen: "Listings", query: .constant(""), type: .constant(""), category: .constant(""))
        }
    }
}
