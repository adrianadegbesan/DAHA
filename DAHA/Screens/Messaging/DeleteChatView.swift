//
//  DeleteChatView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 5/23/23.
//

import SwiftUI
import Firebase

struct DeleteChatView: View {
    
    @State var delete_alert : Bool = false
    @State var error_alert : Bool = false
    @EnvironmentObject var messageManager : MessageManager
    @State var channel : MessageChannelModel
    
    var body: some View {
        VStack{
            Text(Image(systemName: "trash"))
                .font(.system(size: 25, weight: .bold))
                .foregroundColor(.red)
                .onTapGesture {
                    delete_alert = true
                }
        }
        .alert("Delete Chat", isPresented: $delete_alert, actions: {
            Button("Delete", role: .destructive, action: {
                Task{
                   let result = await messageManager.deleteChat(channelID: channel.id)
                    if !result{
                       error_alert = true
                    }
                }
            })
                
            
        }, message: {Text("Are you sure you want to delete this chat?")})
        .alert("Unable to Delete Chat", isPresented: $error_alert, actions: {}, message: {Text("Please check your network connection and try again later.")})
    }
}

//struct DeleteChatView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        let calendar = Calendar.current
//        let startTime = calendar.date(byAdding: .day, value: -2, to: Date())
//        let startTimestamp: Timestamp = Timestamp(date: startTime!)
//
//        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted, gave me alot of miles but kinda creaky sometimes", postedAt: startTimestamp, condition: "Good", category: "Bikes", price: "100", imageURLs: [], channel: "Stanford", savers: [], type: "Request", keywordsForLookup: [], reporters: [])
//
//        let channel = MessageChannelModel(id: "", sender: "1", receiver: "2", users: ["1", "2"], post: post, timestamp: Date(), sender_username: "adrian", receiver_username: "john", channel: "Stanford")
//
//        DeleteChatView(channel: channel)
//    }
//}
