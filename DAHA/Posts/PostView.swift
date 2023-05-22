//
//  PostView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/28/23.
//

import SwiftUI
import Firebase

//Check for if owner in wrapper(list)

struct PostView: View {
    @Binding var post: PostModel
    @State var saved = false
    @State var price = ""
    @State var reported = false
    
//    @State private var selected : Bool = false
    @State private var reported_alert : Bool = false
    @State private var shouldNavigate : Bool = false
    
    @State private var buyNavigate: Bool = false
    @State private var redirect: Bool = true
    @State var channelID : String = ""
    @EnvironmentObject var messageManager : MessageManager
    
    @State var owner : Bool
    @State var preview : Bool
    
    @State private var deletePresented: Bool = false
    @State private var deleted: Bool = false
    @State private var error_alert : Bool = false
    @State private var delete_alert : Bool = false
    @EnvironmentObject var firestoreManager : FirestoreManager
    
    @State private var save_alert: Bool = false
    @State private var unsave_alert: Bool = false
    
    @State private var report_modal: Bool = false
    
    @State var unpostedPreview: Bool?
    @State var unpostedImages: [UIImage]?
    
    @State var userPostNavigate: Bool = false
    
    
    
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                
                PosterInfoView(post: post, preview: preview, unpostedPreview: unpostedPreview)
                Spacer().frame(height: 10)
                
                CategoryView(post: post, screen: "Post", reported: $reported, owner: owner, preview: preview)
                    .frame(width: screenWidth * 0.48)
                   
                
                PostDescriptionView(post: post)
                
                PostActionView(post: $post, saved: $saved, price: $price, owner: owner, preview: preview)
                    .layoutPriority(1)
                    .disabled(reported)
            }
            
            Spacer()
            
            if preview && unpostedPreview != nil && unpostedPreview! {
                PostImageViewUnposted(post: post, owner: owner, preview: preview, reported: reported, unpostedImages: unpostedImages)
            } else {
                PostImageView(post: post, owner: owner, preview: preview, reported: reported)
            }
            
            
            NavigationLink(destination: PostModal(post: $post, price: $price, saved: $saved, reported: $reported, owner: owner), isActive: $shouldNavigate){
                EmptyView()
            }
            
            
            if channelID != "" {
                NavigationLink(destination: ChatScreen(post: post, redirect: false, receiver: post.username, receiverID: post.userID,  channelID: channelID, listen: true, scrollDown: true), isActive: $buyNavigate){
                    EmptyView()
                }
            } else {
                NavigationLink(destination: ChatScreen(post: post, redirect: true, receiver: post.username, receiverID: post.userID), isActive: $buyNavigate){
                    EmptyView()
                }
            }
            
            NavigationLink(destination: UserPostsScreen(username: post.username, userId: post.userID), isActive: $userPostNavigate){
                EmptyView()
            }

           
            
        } //HStack
        .modifier(PostViewModifier(post: post, price: $price, reported: $reported))
//        .frame(width: screenWidth * 0.902, height: 170)
//        .padding()
//        .overlay(
//            RoundedRectangle(cornerRadius: 20)
//                .strokeBorder(((post.price == "Sold" || post.price == "Satisfied") || (price == "Sold" || price == "Satisfied")) ? .green : (reported ? .red : (colorScheme == .dark ? .gray : .gray), lineWidth: colorScheme == .dark ? 2 : 2))
////                .strokeBorder(reported ? .red : (colorScheme == .dark ? .gray : .gray), lineWidth: colorScheme == .dark ? 2 : 2)
////                .shadow(color: colorScheme == .dark ? .white : .black, radius: 1, y: 0)
//        )
//        .background(colorScheme == .dark ? .black.opacity(0.7): .white)
//        .cornerRadius(20)
//        .onAppear{
//            
//            if post.reporters.isEmpty {
//                reported = false
//            } else {
//                let cur_id = Auth.auth().currentUser?.uid
//                if cur_id != nil{
//                    if post.reporters.contains(cur_id!){
//                        reported = true
//                    }
//                } else {
//                    reported = false
//                }
//                
//            }
//          
//        }
        .sheet(isPresented: $report_modal){
            ReportModal(post: post, reported: $reported)
        }
        .alert("Post In Reviewed", isPresented: $reported_alert, actions: {}, message: {Text("We are currently reviewing this post that you have reported.")})
        .onTapGesture {
            if !preview && !reported{
                SoftFeedback()
                shouldNavigate = true
            } else if reported {
                reported_alert = true
            }
        }
        .scaleEffect(preview ? 0.95 : 1)
        .contextMenu{
            
            ExpandPostsMenuButton(preview: preview, shouldNavigate: $shouldNavigate)
//            if !preview {
//                if #available(iOS 16, *){
//                    Button {
//                        shouldNavigate = true
//                    } label: {
//                        Label("Expand Post", systemImage: "arrowshape.right")
//                    }
//                } else {
//                    Button {
//                        shouldNavigate = true
//                    } label: {
//                        Label("Expand Post", systemImage: "arrow.right")
//                    }
//                }
//            }
          
            
            if owner{
                DeletePostMenuButton(post: post, deletePresented: $deletePresented)
//                Button(role: .destructive){
//                    deletePresented = true
//                } label:{
//                    Label("Delete Post", systemImage: "trash")
//                }
//                .foregroundColor(.red)
              
            }
            if !owner{
                if !reported && !preview{
                    
                    ViewPostsButton(post: post, userPostNavigate: $userPostNavigate)
                    
//                    Button{
//                        firestoreManager.user_temp_posts.removeAll()
//                        Task {
//                            await firestoreManager.getUserTempPosts(userId: post.userID)
//                        }
//                        userPostNavigate = true
//                    } label: {
//                        Label("View \(post.username.capitalized)'s Posts")
//                    }
                    if !saved{
                        SavePostMenuButton(post: post, saved: $saved, save_alert: $save_alert)
//                        Button{
//                            Task{
//                                let result = await firestoreManager.savePost(post: post)
//                                if result {
//                                    await firestoreManager.getSaved()
//                                } else {
//                                    save_alert = true
//                                }
//                            }
//                            firestoreManager.saved_refresh = true
//                            withAnimation{
//                                let id = Auth.auth().currentUser?.uid
//                                if id != nil && !post.savers.contains(id!){
//                                    post.savers.append(id!)
//                                    saved.toggle()
//                                }
//                            }
//
//                        } label:{
//                            Label("Save Post", systemImage: "bookmark")
//                        }
                    }
                    
                    
                    if (post.price != "Sold" && post.price != "Satisfied") {
                        Button {
                            redirect = !messageManager.messageChannels.contains(where: {$0.post.id == post.id})
                            if !redirect {
                                let channel = messageManager.messageChannels.first(where: {$0.post.id == post.id})
                                
                                if channel != nil {
                                    channelID = channel!.id
                                }
                            }
                            UIApplication.shared.dismissKeyboard()
                            buyNavigate = true
                        } label:{
                            Label(post.type == "Listing" ? "Buy" : "Give", systemImage: "paperplane")
                        }
                        
                    }
                   
                    
                    Button(role: .destructive){
                        report_modal = true
                    } label:{
                        Label("Report Post", systemImage: "flag")
                    }
                }
            }
        }
        .padding(.horizontal, 3)
        .alert("Delete Post", isPresented: $deletePresented, actions: {
            DeletePostsAlertButton(post: post, error_alert: $error_alert, deleted: $deleted)
//            Button("Delete", role: .destructive, action: {
//                Task{
//                    let delete_success = await firestoreManager.deletePost(post: post, deleted: $deleted, error_alert: $error_alert)
//
//                    if delete_success {
//
//                        withAnimation{
//                            if post.type == "Listing"{
//                                if let index = firestoreManager.listings.firstIndex(where: { $0.id == post.id }) {
//                                    firestoreManager.listings.remove(at: index)
//                                }
//
//
//                            } else if post.type == "Request"{
//                                if let index = firestoreManager.requests.firstIndex(where: { $0.id == post.id }) {
//                                    firestoreManager.requests.remove(at: index)
//                                }
//                            }
//                              if let index = firestoreManager.my_posts.firstIndex(where: { $0.id == post.id }) {
//                                  firestoreManager.my_posts.remove(at: index)
//                              }
//                        }
//
//                    } else {
//                        error_alert = true
//                    }
//                }
//            })
        }, message: {
            Text("Are you sure you want to delete this post?")
        })
        .alert("Unable to Delete Post", isPresented: $error_alert, actions: {}, message: {Text("Please check your network connection and try again later ")})
//        .alert("Post Successfully Deleted", isPresented: $delete_alert, actions: {}, message: {Text("Your post has been deleted")})
        .alert("Error Saving Post", isPresented: $save_alert, actions: {}, message: {Text("Please check your network connection and try again later")})
        .alert("Error Unsaving Post", isPresented: $unsave_alert, actions: {}, message: {Text("Please check your network connection and try again later")})
    
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        let calendar = Calendar.current
        let startTime = calendar.date(byAdding: .day, value: -2, to: Date())
        let startTimestamp: Timestamp = Timestamp(date: startTime!)
        
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted, gave me alot of miles but kinda creaky sometimes", postedAt: startTimestamp, condition: "Good", category: "Bikes", price: "100", imageURLs: [], channel: "Stanford", savers: [], type: "Listing", keywordsForLookup: [], reporters: [])
        NavigationView{
            PostView(post: .constant(post), owner: false, preview: true)
                .environmentObject(FirestoreManager())
                .environmentObject(MessageManager())
        }
    }
}
