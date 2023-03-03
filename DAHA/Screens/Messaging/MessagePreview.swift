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
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        NavigationLink( destination: ChatScreen(post: channel.post, redirect: false, receiver: channel.receiver == Auth.auth().currentUser?.uid ?? "" ? channel.sender_username : channel.receiver_username, channelID: channel.id) ){
            VStack{
                HStack{
                    VStack{
                        HStack{
                            Text("@\(channel.receiver == Auth.auth().currentUser?.uid ?? "" ? channel.sender_username : channel.receiver_username)")
                                .font(.system(size: 18, weight: .bold))
                            Text(Image(systemName: category_images[channel.post.category] ?? "bag.fill"))
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color(hex: category_colors[channel.post.category] ?? "ffffff") )
                            Text(Image(systemName: type_images[channel.post.type] ?? ""))
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color(hex: category_colors[channel.post.category] ?? "ffffff") )
                            
                            Spacer()
                            
                        }
                        
                        HStack{
                            Text(channel.post.title)
                                .font(.system(size: 18, weight: .bold))
                            
                            
                            Spacer()
                            
                        }
                    }
                    Spacer()
                    
                    VStack{
                        HStack{
                            Spacer()
                            Text(channel.timestamp.timeAgoDisplay())
                                .font(.system(size: 13, weight: .bold))
                                .lineLimit(1)
                        }
                        
                        HStack{
                            Spacer()
                            Text("$\(channel.post.price)")
                                .font(.system(size: 18, weight: .bold))
                                .lineLimit(1)
                            
                        }
                        
                        
                    }
                    
                    
                }
                .padding()
                //                Divider()
                
            }
            
            .frame(width: screenWidth, height: screenWidth * 0.2)
        }
        .foregroundColor(colorScheme == .dark ? .white : .black)
        
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
