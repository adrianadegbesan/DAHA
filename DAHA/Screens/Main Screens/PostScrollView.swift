//
//  PostScrollView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/11/23.
//

import SwiftUI
import FirebaseAuth

struct PostScrollView: View {
    
    @Binding var posts: [PostModel]
    @Binding var loading: Bool
    @State var screen: String
    @Binding var query: String
    @Binding var type: String
    @Binding var category: String
    @EnvironmentObject var firestoreManager : FirestoreManager
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("username") var username_system: String = ""
    @AppStorage("id") var user_id = ""
    @State var refresh: Bool = false
    @State var screenOpacity = 0.1
    
    var body: some View {
        ZStack {
            ScrollView{
               
              if posts.isEmpty{
                  VStack{
                      Image("Logo")
                          .opacity(0.8)
                          .overlay(Rectangle().stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
                          .padding(.top, screenHeight * 0.15)
                      if screen == "Saved" {
                          Text("No Saved Posts")
                              .font(.system(size: 20, weight: .black))
                              .padding(.top, 10)
                      }
                    }
                } else {
                    
                    Spacer().frame(height: 10)
                    
                    ForEach(posts) { post in

                        if post.userID == Auth.auth().currentUser?.uid {
                            PostView(post: post, owner: false)
                                .padding(.bottom, 10)
                        } else {
                            PostView(post: post, owner: false)
                                .padding(.bottom, 10)
                        }
                    }
                    
//                    ProgressView()
//                        .padding(.top, 7)
                }
                
            }
            .refreshable {
                refresh.toggle()
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
                withAnimation{
                    screenOpacity = 1
                }
            }
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
