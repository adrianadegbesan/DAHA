//
//  ChatScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/22/23.
//

import SwiftUI
import Firebase

struct ChatScreen: View {
    @State var post: PostModel
    @State var redirect: Bool
    @State var receiver: String
    @State var receiverID: String
    @State var channelID: String?
    @State var listen: Bool?
    @State var sent: Bool = false
    @FocusState var keyboardFocused : Bool
    @EnvironmentObject var messageManager : MessageManager
    @EnvironmentObject var appState : AppState
    @Environment(\.colorScheme) var colorScheme
    @State var listener : ListenerRegistration?
    @State var scrollDown : Bool?
    @State var empty: Bool = true
    @AppStorage("messageScreen") var messageScreen: Bool = false
    
    var body: some View {
        VStack(spacing: 0){
            VStack(spacing: 0){
                Spacer().frame(height: screenHeight * 0.001)
                Divider()
                    .frame(maxHeight: 3)
            }
            .background(colorScheme == .dark ? Color(hex: dark_scroll_background) : Color(hex: greyBackground))
            ScrollViewReader{ value in
                ScrollView{
                    PostView(post: post, owner: false, preview: true)
                        .scaleEffect(0.93)
                    
                    if channelID == nil && empty {
                        Text("Stay safe: Choose to meet only in open, well-lit, public areas and never share personal or sensitive information in the chat.")
                            .foregroundColor(.secondary)
                            .font(.system(size: 11, weight: .semibold))
                            .padding(.horizontal)
                    }
                    
                        
                    if channelID != nil{
                        
                        if (messageManager.messages[channelID!] ?? []).isEmpty {
                            Text("Stay safe: Choose to meet only in open, well-lit, public areas and never share personal or sensitive information in the chat.")
                                .foregroundColor(.secondary)
                                .font(.system(size: 10, weight: .semibold))
                                .padding(.horizontal)
                        }
                        
                        ForEach(messageManager.messages[channelID!] ?? []){ message in
                            MessageBubble(message: message, ChannelID: channelID!)
                                .id(message.id)
                            
                        }
                    }
                }
            
                .onTapGesture {
                    hideKeyboard()
                }
                .onChange(of: messageManager.messages[channelID ?? ""]?.count) { num in
                    
                    if let lastMessage = messageManager.messages[channelID!]?.last {
                        withAnimation{
                            value.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
//                Spacer().frame(height: screenHeight * 0.001)
                MessageField(post: post, channelID: $channelID, sent: $sent, redirect: redirect, keyboardFocused: $keyboardFocused)
                    .onChange(of: sent){ _ in
                        if sent {
                            if let lastMessage = messageManager.messages[channelID!]?.last {
                                withAnimation{
                                    value.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                        sent = false
                    }
                    .onChange(of: keyboardFocused){ _ in
                        if channelID != nil{
                            if keyboardFocused {
                                if let lastMessage = messageManager.messages[channelID!]?.last {
                                    withAnimation{
                                        value.scrollTo(lastMessage.id, anchor: .bottom)
                                    }
                                }
                            }
                        }
                       
                    }
                    .onChange(of: channelID){ _ in
                        if channelID != nil {
                            withAnimation {
                                empty = false
                            }
                            listener = messageManager.getMessages(channelID: channelID!)
                        }
                    }
                    .onAppear{
                        appState.messageScreen = true
                        if listen != nil && channelID != nil{
                            if listen! {
                                listener = messageManager.getMessages(channelID: channelID!)
                            }
                        }
                        if scrollDown != nil{
                            if scrollDown! {
                                if let lastMessage = messageManager.messages[channelID!]?.last {
                                    withAnimation{
                                        value.scrollTo(lastMessage.id, anchor: .bottom)
                                    }
                                }
                            }
                        }
                    }
                    .onDisappear {
                        appState.messageScreen = false
                        if listener != nil{
                            listener?.remove()
                        }
                    }
            }
            .background(colorScheme == .dark ? Color(hex: dark_scroll_background) : Color(hex: greyBackground))
           
            
        }

        .navigationBarTitle("@\(receiver)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: channelID != nil ? MessageOptions(channelID: channelID!, username: receiver, receiverID: receiverID) : nil)
    }
}

struct ChatScreen_Previews: PreviewProvider {
    static var previews: some View {
        let calendar = Calendar.current
        let startTime = calendar.date(byAdding: .day, value: -2, to: Date())
        let startTimestamp: Timestamp = Timestamp(date: startTime!)
        
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted, gave me alot of miles but kinda creaky sometimes", postedAt: startTimestamp, condition: "Good", category: "Bikes", price: "100", imageURLs: [], channel: "Stanford", savers: [], type: "Listing", keywordsForLookup: [], reporters: [])
        
        ChatScreen(post: post, redirect: false, receiver: "Adrian", receiverID: "", channelID: nil)
            .environmentObject(MessageManager())
    }
}
