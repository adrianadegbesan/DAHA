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
    @State var channelID: String?
    @State var sent: Bool = false
    @EnvironmentObject var messageManager : MessageManager
    
    
    var body: some View {
        VStack{
            ScrollViewReader{ value in
                ScrollView{
                    PostView(post: post, owner: false, preview: true)
                        .scaleEffect(0.93)
                    if channelID != nil{
                        ForEach(messageManager.messages[channelID!] ?? []){ message in
                            MessageBubble(message: message)
                                .id(message.id)
                            
                        }
                    }
                }.onAppear{
                    //UPDATE FOR WHEN MESSAGES HAVE LOADED
                    if !redirect {
                        if let lastMessage = messageManager.messages[channelID!]?.last {
                        value.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                .onTapGesture {
                    hideKeyboard()
                }
                MessageField(post: post, channelID: $channelID, sent: $sent)
                    .onChange(of: sent){ _ in
                        if sent {
                            if let lastMessage = messageManager.messages[channelID!]?.last {
                            value.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                        sent = false
                    }
            }
           
            
           
            
        }
        .navigationBarTitle("@\(receiver)")
        
    }
}

struct ChatScreen_Previews: PreviewProvider {
    static var previews: some View {
        let calendar = Calendar.current
        let startTime = calendar.date(byAdding: .day, value: -2, to: Date())
        let startTimestamp: Timestamp = Timestamp(date: startTime!)
        
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted, gave me alot of miles but kinda creaky sometimes", postedAt: startTimestamp, condition: "Good", category: "Bikes", price: "100", imageURLs: [], channel: "Stanford", savers: [], type: "Listing", keywordsForLookup: [], reporters: [])
        
        ChatScreen(post: post, redirect: false, receiver: "Adrian", channelID: nil)
            .environmentObject(MessageManager())
    }
}
