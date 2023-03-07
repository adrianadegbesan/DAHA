//
//  MessageBubble.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/2/23.
//

import SwiftUI
import FirebaseAuth

struct MessageBubble: View {
    var message: MessageModel
    @State var ChannelID : String
    @State private var showTime = false
    @State var error_alert : Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var messageManager : MessageManager
    
    var body: some View {
        VStack(alignment: message.senderID != Auth.auth().currentUser?.uid ?? "" ? .leading : .trailing) {
             HStack {
                 Text(message.message)
                     .foregroundColor(.white)
                     .padding()
                     .background(message.senderID != Auth.auth().currentUser?.uid ? Color(hex: "5A5A5A") : Color(hex: deepBlue))
                     .cornerRadius(30)
             }
             .frame(maxWidth: 300, alignment: message.senderID != Auth.auth().currentUser?.uid  ? .leading : .trailing)
             .onTapGesture {
                 withAnimation{
                     showTime.toggle()
                 }
            
             }
             
             if showTime {
                 Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
                     .font(.caption2)
                     .foregroundColor(.gray)
                     .padding(message.senderID != Auth.auth().currentUser?.uid  ? .leading : .trailing, 5)
             }
         }
         .frame(maxWidth: .infinity, alignment: message.senderID != Auth.auth().currentUser?.uid ? .leading : .trailing)
         .padding(message.senderID != Auth.auth().currentUser?.uid  ? .leading : .trailing)
         .padding(.horizontal, 10)
         .padding(.bottom, 3)
//         .contextMenu {
//             Button(role: .destructive){
//                 Task {
//                     let result = await messageManager.deleteMessage(channelID: ChannelID, messageID: message.id)
//                     if !result{
//                         error_alert = true
//                     }
//                 }
//             } label: {
//                 Label("Delete Message", systemImage: "trash")
//             }
//         }
         .alert("Unable to Delete Post", isPresented: $error_alert, actions: {}, message: {Text("Please check your network connection")})

     }
   }

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        
        let message = MessageModel(id: "", senderID: "", receiverID: "", message: "Here", timestamp: Date(), messageChannelID: "")
        MessageBubble(message: message, ChannelID: "")
    }
}
