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
    @State private var showTime = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: message.senderID != Auth.auth().currentUser?.uid ?? "" ? .leading : .trailing) {
             HStack {
                 Text(message.message)
                     .foregroundColor(colorScheme == .dark ? .white : (message.senderID != Auth.auth().currentUser?.uid ?? "" ? .black : .white))
                     .padding()
                     .background(message.senderID != Auth.auth().currentUser?.uid ? Color("Gray") : Color(hex: deepBlue))
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
                     .padding(message.senderID != Auth.auth().currentUser?.uid  ? .leading : .trailing, 25)
             }
         }
         .frame(maxWidth: .infinity, alignment: message.senderID != Auth.auth().currentUser?.uid ? .leading : .trailing)
         .padding(message.senderID != Auth.auth().currentUser?.uid  ? .leading : .trailing)
         .padding(.horizontal, 10)
     }
   }

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        
        let message = MessageModel(id: "", senderID: "", receiverID: "", message: "Here", timestamp: Date(), messageChannelID: "")
        MessageBubble(message: message)
    }
}
