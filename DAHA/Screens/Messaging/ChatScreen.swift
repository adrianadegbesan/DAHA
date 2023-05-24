//
//  ChatScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/22/23.
//

import SwiftUI
import Firebase
import Shimmer

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
    @State var isAnimating: Bool = false
    @State var message: String = ""
    @State var showTemplate: Bool = true
    @AppStorage("messageScreen") var messageScreen: Bool = false
    @EnvironmentObject var delegate: AppDelegate
    
    @State var shouldNavigate : Bool = false
    @State var shimmer: Bool = true
    
    var body: some View {
        VStack(spacing: 0){
            VStack(spacing: 0){
                Spacer().frame(height: screenHeight * 0.001)
                Divider()
                    .frame(maxHeight: 3)
            }
//            .background(colorScheme == .dark ? Color(hex: dark_scroll_background) : Color(hex: greyBackground))
            ScrollViewReader{ value in
                
                VStack(spacing: 0){
                    ScrollView{
                        
                        VStack(spacing: 0){
                            if redirect {
                                PostView(post: .constant(post), owner: false, preview: true)
                                    .scaleEffect(isAnimating ? 0.98 : 0.93)
                                    .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1), value: isAnimating)
                                    .onLongPressGesture(minimumDuration: 0.5) {
                                         SoftFeedback()
                                         isAnimating = true
                                         DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                            isAnimating = false
                                         }
                                     }
                                    .shimmering (
                                        active: shimmer,
                                        animation: .easeIn(duration: 1.0)
                                    )
                                    .onAppear{
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                                            withAnimation {
                                                shimmer = false
                                            }
                                        }
                                    }
//                                    .onChange(of: message){ value in
//                                        withAnimation{
//                                            shimmer = false
//                                        }
//                                    }
                            } else {
                                PostView(post: .constant(post), owner: false, preview: true)
                                    .scaleEffect(isAnimating ? 0.98 : 0.93)
                                    .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1), value: isAnimating)
                                    .onLongPressGesture(minimumDuration: 0.5) {
                                         SoftFeedback()
                                         isAnimating = true
                                         DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                            isAnimating = false
                                         }
                                     }

                            }
                            
                               SafetyMessageView()
                            
                                Divider()
                                .frame(height: 1.25)
                                .overlay(.secondary)
                                .cornerRadius(15)
                                .padding(.horizontal)
                                .padding(.bottom, 15)
                                .padding(.horizontal, 20)
                            
                            NavigationLink(destination: PostModalPreview(post: post, price: post.price), isActive: $shouldNavigate){
                                EmptyView()
                            }
                            
                            TemplateView(post: post, message: $message, channelID: $channelID, showTemplate: $showTemplate)
                        
                            if channelID != nil{
                                
                                
                                ForEach(messageManager.messages[channelID!] ?? []){ message in
                                    
                                    // if message first in that day( message right before is in day before and not same day, timestamp in middle of hstack above this, in the format Today HH:MM a or Yesterday HH:MM a or if today is wednesday, then Monday HH:MM a, then before that Sunday HH:MM a till a week from today in the format DayOfTheWeek, Month(shortened), day at HH:MM a and beyond
                                    
                                    //message timestamp is found in message.timestamp
                                    
                                    if isFirstMessageOfDay(message, in: messageManager.messages[channelID!] ?? []) {
                                           Text(getFormattedDate(message.timestamp))
                                            .font(.system(size: 12.5, weight: .semibold))
                                               .foregroundColor(.secondary)
                                               .padding()
                                            
                                   }
                                    
                                    MessageBubble(message: message, ChannelID: channelID!)
                                    
                                    if message.id == messageManager.messages[channelID!]?.last?.id {
                                        Spacer().frame(height: 8)
                                        Text("     ")
                                            .foregroundColor(.clear)
                                            .id(message.id)
                                     } else {
                                         Spacer().frame(height: 5)
                                             .id(message.id)
                                     }
                                    
                                }
                                
                            }
                            
                          
                           
                        }
                    
                     
                        .onChange(of: messageManager.messages[channelID ?? ""]?.count) { num in
                            
                            if let lastMessage = messageManager.messages[channelID!]?.last {
                                withAnimation{
                                    value.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                       
                    }
                    .onTapGesture {
                        hideKeyboard()
                    }
                    Divider()
                   
    //                Spacer().frame(height: screenHeight * 0.001)
                    HStack{
                        MessageField(message: $message, post: post, channelID: $channelID, sent: $sent, redirect: redirect, keyboardFocused: $keyboardFocused)
                            .padding(.top, 10)
                            .padding(.bottom, 4)
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
                                        listener = messageManager.getMessages(channelID: channelID!)
                                    }
                                  
                                }
                            }
                            .onAppear{
                                appState.messageScreen = true
                                delegate.chatScreen = true
                                delegate.currentChat = "\(receiver)"
                                if listen != nil && channelID != nil{
                                    if listen! {
                                        listener = messageManager.getMessages(channelID: channelID!)
                                    }
                                }
//                                if scrollDown != nil{
//                                    if scrollDown! {
//                                        if let lastMessage = messageManager.messages[channelID!]?.last {
//                                            withAnimation{
//                                                value.scrollTo(lastMessage.id, anchor: .bottom)
//                                            }
//                                        }
//                                    }
//                                }
                            }
                            .onDisappear {
                                appState.messageScreen = false
                                delegate.chatScreen = false
                                delegate.currentChat = ""
                                if listener != nil{
                                    listener?.remove()
                                }
                            }
                    }
//                    .background(colorScheme == .dark ? Color(hex: dark_scroll_background) : Color(hex: light_scroll_background))
                    
                    }
                    
                }
            
        }

        .navigationBarTitle("@\(receiver)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: channelID != nil ? MessageOptions(post: post, channelID: channelID!, username: receiver, receiverID: receiverID, shouldNavigate: $shouldNavigate) : nil)
    }
    
    func isFirstMessageOfDay(_ message: MessageModel, in messages: [MessageModel]) -> Bool {
           guard let index = messages.firstIndex(where: { $0.id == message.id }),
                 index > 0 else {
               return true
           }
           return !Calendar.current.isDate(message.timestamp, inSameDayAs: messages[index - 1].timestamp)
       }
       
       // Format date as needed
    func getFormattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()

        let calendar = Calendar.current
        if calendar.component(.year, from: date) == calendar.component(.year, from: Date()) {
            // If the year is the same, don't include the year in the format
            formatter.dateFormat = "EEEE, MMM d, h:mm a"
        } else {
            // If the year is different, include the year in the format
            formatter.dateFormat = "EEEE, MMM d, yyyy, h:mm a"
        }

        return formatter.string(from: date)
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
