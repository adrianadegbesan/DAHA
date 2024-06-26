//
//  BuyButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/29/23.
//

import SwiftUI
import Firebase

struct BuyButton: View {
    
    @State var post: PostModel
    @State private var shouldNavigate: Bool = false
    @State private var redirect: Bool = true
    @State private var channelID: String = ""
    @EnvironmentObject var messageManager : MessageManager
    @Environment(\.colorScheme) var colorScheme
    @State var listener : ListenerRegistration?
    
    var body: some View {
        Button(action: {
            //MessagingAction
            SoftFeedback()
            redirect = !messageManager.messageChannels.contains(where: {$0.post.id == post.id})
            
            if !redirect{
                let channel = messageManager.messageChannels.first(where: {$0.post.id == post.id})
                
                if channel != nil{
                    channelID = channel!.id
                    listener = messageManager.getMessages(channelID: channelID)
                }
            }
            UIApplication.shared.dismissKeyboard()
            shouldNavigate = true
            
        }){
            HStack(spacing: 0){
                Text(post.type == "Request" ? "GIVE " : "BUY ")
                    .minimumScaleFactor(0.05)
                    .fixedSize(horizontal: true, vertical: false)
                    .font(.system(size: 13, weight: .bold))
                
                    .layoutPriority(1)
                    .lineLimit(1)
                Image(systemName: "paperplane.fill")
                    .minimumScaleFactor(0.05)
                    .font(.system(size: 13, weight: .bold))
                
                if channelID != ""{
                    NavigationLink(destination: ChatScreen(post: post, redirect: false, receiver: post.username, receiverID: post.userID,  channelID: channelID, listen: true), isActive: $shouldNavigate){
                        EmptyView()
                    }
                    .buttonStyle(.plain)
                } else {
                    NavigationLink(destination: ChatScreen(post: post, redirect: true, receiver: post.username, receiverID: post.userID), isActive: $shouldNavigate){
                        EmptyView()
                    }
                    .buttonStyle(.plain)
                }
                
               
                
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            //            .font(.system(size: 15, weight: .bold))
            .foregroundColor(.white)
            .background(Capsule().fill(Color(hex: deepBlue)))
            .overlay{
                if colorScheme == .light{
                    Capsule().stroke(.black, lineWidth: 2)
                } else {
                    Capsule().stroke(.white, lineWidth: 1.5)
                }
            }
            .onDisappear{
                if listener != nil{
                    listener?.remove()
                }
            }
        }
        .buttonStyle(.plain)
    }
}

struct BuyButton_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "", keywordsForLookup: [], reporters: [])
        NavigationView{
            BuyButton(post: post)
        }
    }
}
