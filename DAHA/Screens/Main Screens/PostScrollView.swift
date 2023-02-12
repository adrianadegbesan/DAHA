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
    
    var body: some View {
        ScrollView{
            
           
            
            if posts.isEmpty{
                ProgressView()
                    .padding(.top, 10)
            } else {
                
                Spacer().frame(height: 10)
                
                ForEach(posts) { post in
                    

                    if post.userID == firestoreManager.userId{
                        PostView(post: post, owner: true)
                            .padding(.bottom, 10)
                    } else {
                        PostView(post: post, owner: false)
                            .padding(.bottom, 10)
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
        .onChange(of: posts.count){ value in
            print(posts)
        }
        .onChange(of: loading){ value in
            print(loading)
            
        }
    }
    
    struct PostScrollView_Previews: PreviewProvider {
        static var previews: some View {
            let posts : [PostModel] = []
            
            PostScrollView(posts: .constant(posts), loading: .constant(false), screen: "Listings", query: .constant(""), type: .constant(""), category: .constant(""))
                .environmentObject(FirestoreManager())
        }
    }
}
