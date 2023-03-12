//
//  MessagePreview.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/22/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct MessagePreview: View {
    
    @State var channel : MessageChannelModel
    
    //State var MessageObject
    @State var timestampString : String = ""
    @State var delete_alert : Bool = false
    @State var error_alert : Bool = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var messageManager : MessageManager
    @State var listener : ListenerRegistration?
    
    var body: some View {
        
        NavigationLink( destination: ChatScreen(post: channel.post, redirect: false, receiver: channel.receiver == Auth.auth().currentUser?.uid ?? "" ? channel.sender_username : channel.receiver_username, receiverID:  channel.receiver == Auth.auth().currentUser?.uid ?? "" ? channel.sender : channel.receiver, channelID: channel.id, listen: true) ){
            VStack{
                HStack{
                    VStack{
                        HStack{
                            Text("@\(channel.receiver == Auth.auth().currentUser?.uid ?? "" ? channel.sender_username : channel.receiver_username)")
                                .font(.system(size: 15, weight: .bold))
                            Spacer()
                            
                        }
                        
                        HStack{
                            Text(channel.post.title)
                                .font(.system(size: 15, weight: .bold))
                            
                            
                            Spacer()
                            
                        }
                    }
                    Spacer()
                    
                    HStack{
                        Text(Image(systemName: category_images[channel.post.category] ?? "bag.fill"))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(colorScheme == .dark && channel.post.category == "General" ? .white : Color(hex: category_colors[channel.post.category] ?? "ffffff") )
                        Text(Image(systemName: type_images[channel.post.type] ?? ""))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(colorScheme == .dark && channel.post.category == "General" ? .white : Color(hex: category_colors[channel.post.category] ?? "ffffff") )
                        
                    }
                    
                    VStack{
                        HStack{
                            Spacer()
                            Text(timestampString)
                                .font(.system(size: 13, weight: .bold))
                                .lineLimit(1)
                                .onAppear{
                                    timestampString = channel.timestamp.timeAgoDisplay()
                                }
                        }
                        
                        HStack{
                            Spacer()
                            (Text(channel.post.price == "Free" ? "" : "$") + Text(channel.post.price))
                                .font(.system(size: 15, weight: .bold))
                                .lineLimit(1)
                            
                        }
                    }
                    
                    
                }
                .padding()
                
            }
            
            .frame(width: screenWidth, height: screenWidth * 0.2)
          
            
        }
        .foregroundColor(colorScheme == .dark ? .white : .black)
        .contextMenu {
            Button(role: .destructive){
                delete_alert = true
            } label:{
                Label("Delete Chat", systemImage: "trash")
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
       
        .onAppear{
            listener = messageManager.getMessages(channelID: channel.id)
        }
        .onDisappear{
            if listener != nil{
                listener?.remove()
            }
        }
    }
    
}

struct MessagePreview_Previews: PreviewProvider {
    static var previews: some View {
        let calendar = Calendar.current
        let startTime = calendar.date(byAdding: .day, value: -2, to: Date())
        let startTimestamp: Timestamp = Timestamp(date: startTime!)
        
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted, gave me alot of miles but kinda creaky sometimes", postedAt: startTimestamp, condition: "Good", category: "Bikes", price: "100", imageURLs: [], channel: "Stanford", savers: [], type: "Request", keywordsForLookup: [], reporters: [])
        
        let channel = MessageChannelModel(id: "", sender: "1", receiver: "2", users: ["1", "2"], post: post, timestamp: Date(), sender_username: "adrian", receiver_username: "john", channel: "Stanford")
        MessagePreview(channel: channel)
    }
}
