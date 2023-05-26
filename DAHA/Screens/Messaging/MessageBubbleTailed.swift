//
//  MessageBubbleTail.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 4/22/23.
//

import SwiftUI
import FirebaseAuth

struct MessageBubbleTailed: View {
    var message: MessageModel
    @State var ChannelID : String
    @State private var showTime = false
    @State private var error_alert : Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var messageManager : MessageManager
    
    var body: some View {
        VStack{
            ChatBubble(direction: message.senderID != Auth.auth().currentUser?.uid ?? "" ? .left : .right){
                Text(message.message)
                    .foregroundColor(colorScheme == .dark ? .white : (message.senderID != Auth.auth().currentUser?.uid ? .black : .white))
                    .padding(15)
                    .background(message.senderID != Auth.auth().currentUser?.uid ? Color(hex: colorScheme == .dark ? messageBubbleReceiver_dark : messageBubbleReceiver_light) : Color(hex: messageSender))
                    .onTapGesture {
                        withAnimation{
                            showTime.toggle()
                        }
                    }
            }

            HStack{

                if message.senderID == Auth.auth().currentUser?.uid{
                    Spacer()
                }

                if showTime {
                    if Calendar.current.isDateInToday(message.timestamp) {
                          Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
                              .font(.caption2)
                              .foregroundColor(.gray)
                              .padding(message.senderID != Auth.auth().currentUser?.uid  ? .leading : .trailing, 5)
                              .padding(.bottom, 4)
                      } else {
                          Text("\(message.timestamp.formatted(.dateTime.hour().minute())) - \(message.timestamp.formatted(.dateTime.month().day().year()))")
                              .font(.caption2)
                              .foregroundColor(.gray)
                              .padding(message.senderID != Auth.auth().currentUser?.uid  ? .leading : .trailing, 5)
                              .padding(.bottom, 4)
                      }
                }

                if message.senderID != Auth.auth().currentUser?.uid{
                    Spacer()
                }

            }


        }
        .frame(maxWidth: .infinity, alignment: message.senderID != Auth.auth().currentUser?.uid ? .leading : .trailing)
        .padding(message.senderID != Auth.auth().currentUser?.uid  ? .leading : .trailing)
    }
}

struct MessageBubbleTail_Previews: PreviewProvider {
    static var previews: some View {
        let message = MessageModel(id: "", senderID: "", receiverID: "", message: "Here", timestamp: Date(), messageChannelID: "")
        
        MessageBubbleTailed(message: message, ChannelID: "")
    }
}
