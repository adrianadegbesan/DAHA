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
    @State private var targetPostID: String? = nil
    @State private var currentPostID: String = ""
    @State private var isAnimating: Bool = false
    
    @State var screenOpacity = 0.1
//    @State var time = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()
    
    @State var categoryFilter = ""

    private func loadMorePostsIfNeeded(_ currentPostID: String, screen: String) {
            if currentPostID == targetPostID {
                // Update the target post ID for the next trigger
                targetPostID = nil
                
                if screen == "Search" {
                    if firestoreManager.search_last != nil{
                        Task {
                            await firestoreManager.updateSearch(query: query.lowercased().trimmingCharacters(in: .whitespacesAndNewlines), type: type, category: category)
                        }
                    }
                   
                }
                else if screen == "Listings"{
                    
                    if firestoreManager.listing_last != nil {
                        if categoryFilter == ""{
                            Task {
                               await  firestoreManager.updateListings()
                            }
                        } else {
                            
                            if firestoreManager.listings_filtered_last != nil{
                                Task {
                                    await firestoreManager.updateListingsFiltered(category: categoryFilter)
                                }
                            }
                        }
                    }
                   
                   
                }

                else if screen == "Requests" {
                    
                    if firestoreManager.requests_last != nil {
                        if categoryFilter == "" {
                            Task {
                                await firestoreManager.updateRequests()
                            }
                        } else {
                            
                            if firestoreManager.requests_filtered_last != nil{
                                Task {
                                    await firestoreManager.updateRequestsFiltered(category: categoryFilter)
                                }
                            }
                           
                        }
                        
                    }
                    
                   
                    
                }

                else if screen == "Saved" {
                    
                    if firestoreManager.saved_last != nil{
                        Task {
                            await firestoreManager.updateSaved()
                        }
                    }
                   
                }

                else if screen == "User" {
                    
                    if firestoreManager.user_last != nil{
                        Task {
                            await firestoreManager.updateUserPosts()
                        }
                    }
                   
                }
                
            }
    }
    
    var body: some View {
        ZStack {
          
            GeometryReader { g in
                
                ScrollViewReader { value in
                    RefreshableScrollView {
                    
//                        if #available(iOS 16, *){
                            if screen != "Saved" && screen != "User" && screen != "Search"{
                                
                                Spacer().frame(height: 12)
                                CategoryFilterView(selected: $categoryFilter, screen: screen, posts: $posts, loading: $loading)
                                    .padding(.bottom, 3)
                            }
                    
//                        }
                 
                        
                        if posts.isEmpty && screen == "Search" {
                            if loading {
                                ZStack {
                                    ProgressView()
                                        .scaleEffect(1.2)
                                        .padding(.top, 10)
                                }
                                .frame(width: screenWidth)
                                
                            }
                            if !loading {
                                ZStack {
                                    LazyVStack {
                                        Image(systemName: "magnifyingglass")
                                            .font(.system(size: 95, weight: .bold))
                                            .foregroundColor(Color(hex: deepBlue))
                                            .scaleEffect(isAnimating ? 1.2 : 1.0)
                                            .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1), value: isAnimating)
                                            .onLongPressGesture(minimumDuration: 0.5) {
                                                 SoftFeedback()
                                                 isAnimating = true
                                                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                                    isAnimating = false
                                                 }
                                             }
                                        .padding(.top, screenHeight * 0.15)
                                        Text("No results found")
                                            .font(.system(size: 25, weight: .semibold))
                                    }

                                }
                                .frame(width: screenWidth)
                            }
                        }

                      if posts.isEmpty && screen != "Search" {
                          
                          if loading && screen != "Saved"{
                              Spacer().frame(height: 12)
                              
                              LazyVStack {
                                  
                                  if #available(iOS 16, *){
                                      EmptyView()
                                  } else {
                                      Spacer().frame(height: 45)
                                  }
                                  
//                                  ProgressView()
//                                      .scaleEffect(1.2)
//                                      .padding(.top, 10)
                                  PostShimmerScroll()
                              }
                              .frame(width: screenWidth)
                          } else {
                              Spacer().frame(height: 12)
                              
                              LazyVStack {
                                 
                                
                                  Image("Logo")
                                      .opacity(colorScheme == .dark ? 0.75 : 0.9)
                                      .overlay(Rectangle().stroke(.white, lineWidth: 2))
                                      .scaleEffect(isAnimating ? 1.1 : 1.0)
                                      .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1), value: isAnimating)
                                      .onTapGesture{
                                           SoftFeedback()
                                           isAnimating = true
                                           DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                              isAnimating = false
                                           }
                                       }
                                      .padding(.top, screenHeight * 0.15)
                                }
                              .frame(width: screenWidth)
                          }
                        
                        } else {
                            
                            
                            LazyVStack{
                                if screen != "Listings" && screen != "Requests"{
                                    Spacer().frame(height: 12)
                                }
                                
                                if #available(iOS 16, *){
                                    EmptyView()
                                } else {
                                    if screen == "Listings" || screen == "Requests"{
                                        Spacer().frame(height: 55)
                                    }
                                }
                                
                                ForEach(posts.indices, id: \.self) { index in
                                 let post = posts[index]
                                    
//                                    if post.reporters.contains(Auth.auth().currentUser?.uid ?? "") {
//                                        EmptyView()
//                                    } else {
                                        PostView(post: post, owner: (post.userID == Auth.auth().currentUser?.uid), preview: false)
                                            .id(post.id)
                                            .padding(.leading, 3)
                                            .padding(.bottom, 10)
                                            .onAppear {
                                                currentPostID = post.id
                                                if index == posts.count - 1 {
                                                    if targetPostID != post.id{
                                                        targetPostID = post.id
                                                    }
                                                }
                                            }
//                                    }
                                
                                }
                                PostShimmer()
                                    .padding(.leading, 3)
                                    .padding(.bottom, 10)
                                
//                                if posts.count > 10 && screen == "Listings" || screen == "Requests"){
//                                    Spacer().frame(height: 12)
//                                    ProgressView()
//                                    
//                                }
                             
                               
                                
                            } //: LAZY VSTACK
                            .onChange(of: targetPostID){ id in
                                loadMorePostsIfNeeded(currentPostID, screen: screen)
                            }
                            
                        } //POSTS NOT EMPTY
                        
                    }/*SCROLLVIEW*/
                    
//                    .background(colorScheme == .dark ? Color(hex: dark_scroll_background) : Color(hex: greyBackground))
                    .refreshable(action: {
                        LightFeedback()
                        if screen == "Listings"{
                            if categoryFilter == ""{
                                Task {
                                     await firestoreManager.getListings()
                                }
                            } else {
                                Task {
                                    await firestoreManager.getListingsFiltered(category: categoryFilter)
                                }
                            }
                            
                        }
                        
                        if screen == "Requests" {
                            if categoryFilter == ""{
                                Task {
                                     await firestoreManager.getRequests()
                                }
                            } else {
                                Task{
                                    await firestoreManager.getRequestsFiltered(category: categoryFilter)
                                }
                            }
                            
                        }
                        
                        if screen == "Saved" {
                            Task {
                                await firestoreManager.getSaved()
                                await firestoreManager.getMetrics()
                            }
                        }
                        
                        if screen == "User" {
                            Task {
                                await firestoreManager.userPosts()
                                await firestoreManager.getMetrics()
                            }
                        }
                    })
                    .onAppear{
                        if screen == "Listings"{
                            if firestoreManager.listings_refresh {
                                firestoreManager.listings_refresh = false
                               
                                Task {
                                   categoryFilter = ""
                                   await firestoreManager.getListings()
                                    }
                                }
                        }
                            

                        if screen == "Requests" {
                            if firestoreManager.requests_refresh {
                                firestoreManager.requests_refresh = false
                                Task {
                                   categoryFilter = ""
                                   await firestoreManager.getRequests()
                                    }
                                }
                        }
                        
                        if screen == "Saved"{
                            if firestoreManager.saved_refresh{
                                firestoreManager.saved_refresh = false
                                Task {
                                    await firestoreManager.getSaved()
                                }
                            }
                           
                        }
                        
                        if screen == "User"{
                            if firestoreManager.user_refresh{
                                firestoreManager.user_refresh = false
                                Task {
                                    await firestoreManager.userPosts()
                                }
                                
                            }
                            
                        }
                        withAnimation{
                            screenOpacity = 1
                        }
                  }
                    .onChange(of: firestoreManager.scroll_up){ num in
                        if firestoreManager.scroll_up {
                            if screen == "Listings"{
                                if !firestoreManager.listings.isEmpty{
                                    let id = firestoreManager.listings[0].id
                                    withAnimation{
                                        value.scrollTo(id, anchor: .bottom)
                                    }
                                }
                                firestoreManager.scroll_up = false
                            }
                            if screen == "Requests"{
                                if !firestoreManager.requests.isEmpty{
                                    let id = firestoreManager.requests[0].id
                                    withAnimation{
                                        value.scrollTo(id, anchor: .bottom)
                                    }
                                }
                                firestoreManager.scroll_up = false
                            }
                            
                            if screen == "User"{
                                if !firestoreManager.my_posts.isEmpty{
                                    let id = firestoreManager.my_posts[0].id
                                    withAnimation{
                                        value.scrollTo(id, anchor: .bottom)
                                    }
                                }
                                firestoreManager.scroll_up = false
                            }
                            
                        }
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
