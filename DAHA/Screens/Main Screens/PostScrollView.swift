//
//  PostScrollView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/11/23.
//

import SwiftUI
import FirebaseAuth
import RefreshableScrollView

struct PostScrollView: View {
    
    @Binding var posts: [PostModel]
    @Binding var loading: Bool
    @State var screen: String
    @Binding var query: String
    @Binding var type: String
    @Binding var category: String
    @EnvironmentObject var firestoreManager : FirestoreManager
    @Environment(\.colorScheme) var colorScheme
    @State var screenOpacity = 0.1
    @State var time = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()
    
    var body: some View {
        ZStack {
          
            GeometryReader { g in
                
                RefreshableScrollView{
//                        ProgressView()
//                            .offset(y: -40)
//                            .scaleEffect(1.2)
//

                  if posts.isEmpty{
                      VStack{
                          Image("Logo")
                              .opacity(0.8)
                              .overlay(Rectangle().stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
                              .padding(.top, screenHeight * 0.15)
                              .padding(.leading, screenWidth * 0.35)
//                          if screen == "Saved" {
//                              Text("No Saved Posts")
//                                  .font(.system(size: 16, weight: .heavy))
//                                  .padding(.top, 10)
//                                  .padding(.leading, screenWidth * 0.35)
//                          }
                        }
                    } else {
                        
                        Spacer().frame(height: 3)
                        
                        ForEach(posts) { post in
                            
                            ZStack{
                                if post.userID == Auth.auth().currentUser?.uid {
                                    
                                    if post.id == posts.last!.id {
//                                        GeometryReader{ g in
                                        PostView(post: post, owner: true)
                                                .padding(.bottom, 10)
                                                .onAppear{
                                                    self.time = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()
                                                }
                                                .onReceive(self.time) { (_) in
                                                    if g.frame(in: .global).maxY < UIScreen.main.bounds.height - 80{
                                                        if screen == "Search" {
                                                            print("updating")
                                                            Task {
                                                                await firestoreManager.updateSearch(query: query.lowercased().trimmingCharacters(in: .whitespacesAndNewlines), type: type, category: category)
                                                            }
                                                        }
                                                        else if screen == "Listings"{
                                                            Task {
                                                                await firestoreManager.updateListings()
                                                            }
                                                        }

                                                        else if screen == "Requests" {
                                                            Task {
                                                                await firestoreManager.updateRequests()
                                                            }
                                                        }

                                                        else if screen == "Saved" {
                                                            Task {
                                                                await firestoreManager.updateSaved()
                                                            }
                                                        }

                                                        else if screen == "User" {
                                                            Task {
                                                                await firestoreManager.updateUserPosts()
                                                            }
                                                        }
                                                        
                                                        
//                                                        print("Updating data")
                                                        
                                                        self.time.upstream.connect().cancel()
                                                    } //UPDATE FUNCTIONS
                                                    
                                                } //ONRECEIVE
//                                          }  //GEOMETRY READER
//                                        .frame(height: 65)
                                    } else {
                                        PostView(post: post, owner: true)
                                            .padding(.bottom, 10)
                                    } //NOT LAST
                                  
                                } /*USER POST*/else {
                                    if post.id == posts.last!.id  {
//                                        GeometryReader{ g in
                                        PostView(post: post, owner: false)
                                                .padding(.bottom, 10)
                                                .onAppear{
                                                    self.time = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()
                                                }
                                                .onReceive(self.time) { (_) in
                                                    if g.frame(in: .global).maxY < UIScreen.main.bounds.height - 80{
                                                        if screen == "Listings"{
                                                            Task {
                                                                await firestoreManager.updateListings()
                                                            }
                                                        }

                                                        if screen == "Requests" {
                                                            Task {
                                                                await firestoreManager.updateRequests()
                                                            }
                                                        }

                                                        if screen == "Saved" {
                                                            Task {
                                                                await firestoreManager.updateSaved()
                                                            }
                                                        }

                                                        if screen == "User" {
                                                            Task {
                                                                await firestoreManager.updateUserPosts()
                                                            }
                                                        }
                                                        
                                                        if screen == "Search"{
                                                            Task {
                                                                await firestoreManager.updateSearch(query: query.lowercased().trimmingCharacters(in: .whitespacesAndNewlines), type: type, category: category)
                                                            }
                                                        }
                                                        
                                                        print("Updating data")
                                                        
                                                        self.time.upstream.connect().cancel()
                                                    } //UPDATE FUNCTIONS
                                                    
                                                } //ONRECEIVE
//                                          } //GEOMETRY READER
//                                        .frame(height: 65)
                                    } else {
                                        PostView(post: post, owner: false)
                                            .padding(.bottom, 10)
                                    }
                                    
                                 
                                } //NOT USER POST
                                
                            } //ZSTACK

                       
                        } //FOREACHLOOP
                        
                    } //POSTS NOT EMPTY
                    
                } /*SCROLLVIEW*/
                .refreshable(action: {
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
                })
//                .refreshable {
//                    if screen == "Listings"{
//                        Task {
//                            await firestoreManager.getListings()
//                        }
//                    }
//
//                    if screen == "Requests" {
//                        Task {
//                            await firestoreManager.getRequests()
//                        }
//                    }
//
//                    if screen == "Saved" {
//                        Task {
//                            await firestoreManager.getSaved()
//                        }
//                    }
//
//                    if screen == "User" {
//                        Task {
//                            await firestoreManager.userPosts()
//                        }
//                    }
//
//                    if screen == "Search" {
//                        Task {
//                            await firestoreManager.searchPosts(query: query, type: type, category: category)
//                        }
//                    }
//                }
                .onAppear{
                    if screen == "Listings"{
                        Task {
                            await firestoreManager.getRequests()
                        }
                    }

                    if screen == "Requests" {
                        Task {
                            await firestoreManager.getListings()
                        }
                    }

                    if screen == "Saved" {
                        Task {
                            await firestoreManager.getSaved()
//                            await firestoreManager.getListings()
//                            await firestoreManager.getRequests()
                        }
                    }

                    if screen == "User" {
                        Task {
                            await firestoreManager.userPosts()
//                            await firestoreManager.getListings()
//                            await firestoreManager.getRequests()
                        }
                    }
                    withAnimation{
                        screenOpacity = 1
                    }
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
