//
//  MessageField.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/3/23.
//

import SwiftUI
import Firebase


struct MessageField: View {
    @EnvironmentObject var messagesManager: MessageManager
    @State private var message = ""
    @State private var previousMessage = ""
    @State var post: PostModel
    @Binding var channelID : String?
    @State var sending : Bool = false
    @Binding var sent : Bool
    @State var redirect : Bool
    @State var error_alert : Bool = false
    var keyboardFocused: FocusState<Bool>.Binding

    var body: some View {
        
        HStack {
            HStack {
                //             Custom text field created below
                CustomTextField(placeholder: Text(""), text: $message, commit: {
                    
                }, keyboardFocused: keyboardFocused, redirect: redirect)
                    .frame(height: 40)
                
            }
            .padding(.horizontal, screenWidth * 0.025)
            .background(RoundedRectangle(cornerRadius: 50).stroke(lineWidth: 0.8))
            .padding(.bottom, 3)
            .alert("Error Sending Message", isPresented: $error_alert, actions: {}, message:{Text("Please check your network connection")})
            
            Button {
                if message.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    SoftFeedback()
                    
                    
                    if channelID == nil {
                        previousMessage = message
                        message = ""
                        
                        Task{
                           let success =  await messagesManager.createMessageChannel(message: previousMessage, post: post, channelID: $channelID, error_alert: $error_alert)
                            if !success {
                                message = previousMessage
                            }
                        }
                
                    } else {
                        previousMessage = message
                        message = ""
                        
                        Task{
                            let cur_id = Auth.auth().currentUser?.uid
                            if cur_id != nil {
                                var receiverID = ""
                                
                                if !(messagesManager.messageChannels.contains(where: {$0.id == channelID!})){
                                    let channel = await messagesManager.getChannel(channelID: channelID!)
                                    if channel != nil{
                                        if channel!.receiver == cur_id {
                                            receiverID = channel!.sender
                                        } else {
                                            receiverID = channel!.receiver
                                        }
                                        let success = await messagesManager.sendMessage(message: previousMessage, channelID: channelID!, post: post, sent: $sent, receiverID: receiverID, error_alert: $error_alert)
                                        if !success {
                                            message = previousMessage
                                        }
                                    }
                                    
                                } else {
                                    let index = messagesManager.messageChannels.firstIndex(where: {$0.id == channelID! })
                                    if index != nil{
                                        let channel = messagesManager.messageChannels[index!]
                                        if channel.receiver == cur_id {
                                            receiverID = channel.sender
                                        } else {
                                            receiverID = channel.receiver
                                        }
                                        let success = await messagesManager.sendMessage(message: previousMessage, channelID: channelID!, post: post, sent: $sent, receiverID: receiverID, error_alert: $error_alert)
                                        if !success {
                                            message = previousMessage
                                        }
                                    } else {
                                        return
                                    }
                                }
                                
                            } else {
                                return
                            }
                        }
                    } 
                }
                
            } label: {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundColor(.white)
//                    .rotationEffect(.degrees(40.0))
                    .padding(10)
                    .background(message != "" ? Color(hex: deepBlue) : .gray)
                    .cornerRadius(50)
                    .offset(x: screenWidth * 0.003)
            }
            
        }
        .padding(.horizontal, screenWidth * 0.015)
        .padding(.bottom, 3)
    }
        
        
        
        
}

//struct MessageField_Previews: PreviewProvider {
//    static var previews: some View {
//        let calendar = Calendar.current
//        let startTime = calendar.date(byAdding: .day, value: -2, to: Date())
//        let startTimestamp: Timestamp = Timestamp(date: startTime!)
//
//        var keyboardFocused: FocusState<Bool>.Binding
//        
//        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted, gave me alot of miles but kinda creaky sometimes", postedAt: startTimestamp, condition: "Good", category: "Bikes", price: "100", imageURLs: [], channel: "Stanford", savers: [], type: "Listing", keywordsForLookup: [], reporters: [])
//
//        MessageField(post: post, channelID: .constant(nil), sent: .constant(false), keyboardFocused: keyboardFocused)
//            .environmentObject(MessageManager())
//    }
//}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    var keyboardFocused: FocusState<Bool>.Binding
    var redirect: Bool

    var body: some View {
        ZStack(alignment: .leading) {
            // If text is empty, show the placeholder on top of the TextField
            if text.isEmpty {
                placeholder
                .opacity(0.5)
            }
            
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                .focused(keyboardFocused)
                .onAppear{
                    if redirect{
                        keyboardFocused.wrappedValue = true
                    }
                }
                
            
        }
    }
}
