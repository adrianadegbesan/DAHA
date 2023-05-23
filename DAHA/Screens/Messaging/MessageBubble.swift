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
    @State private var dragOffset = CGSize.zero
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var messageManager : MessageManager
    
    var body: some View {
        
        
        VStack(alignment: message.senderID != Auth.auth().currentUser?.uid ?? "" ? .leading : .trailing) {
            
            ZStack(alignment: message.senderID != Auth.auth().currentUser?.uid ?? "" ? .leading : .trailing){
                if message.senderID != Auth.auth().currentUser?.uid {
                     TimestampView(message: message)
                        .offset(x: dragOffset.width > 0.0 ? dragOffset.width - 145 : -180.0)  // Move it with the bubble
                 }
                if message.senderID == Auth.auth().currentUser?.uid {
                    TimestampView(message: message)
                        .offset(x: dragOffset.width < 0.0 ? dragOffset.width + 145 : 180.0)  // Move it with the bubble
                }
                
                HStack {
                    Text(message.message)
                        .foregroundColor(colorScheme == .dark ? .white : (message.senderID != Auth.auth().currentUser?.uid ? .black : .white))
                        .padding(13)
                        .background(message.senderID != Auth.auth().currentUser?.uid ? Color(hex: colorScheme == .dark ? messageBubbleReceiver_dark : messageBubbleReceiver_light) : Color(hex: messageSender))
                        .cornerRadius(25)
   //                     .contextMenu {
   //                         Button {
   //                            UIPasteboard.general.string = message.message
   //                         } label:{
   //                             Label("Copy", systemImage: "doc.on.doc")
   //                         }
   //                     }
                }
                .frame(maxWidth: 245, alignment: message.senderID != Auth.auth().currentUser?.uid  ? .leading : .trailing)
                .offset(x: dragOffset.width)
                .gesture(  // Handle the drag gesture
                    DragGesture()
                        .onChanged { value in
                            // Adjust the offset as the user drags
                            if message.senderID != Auth.auth().currentUser?.uid {
                                // For leading-aligned bubbles, allow dragging to the right
                                if value.translation.width > 0 && value.translation.width < 150 {
                                    withAnimation{
                                        dragOffset = value.translation
                                    }
                                   
                                }
                            } else {
                                // For trailing-aligned bubbles, allow dragging to the left
                                if value.translation.width < 0 && value.translation.width > -150 {
                                    withAnimation{
                                        dragOffset = value.translation
                                    }
                                }
                            }
                        }
                        .onEnded { value in
                            // Reset the offset when the user ends the drag
                            withAnimation {
                                dragOffset = .zero
                            }
                        }
               )
            }
         }

         .frame(maxWidth: .infinity, alignment: message.senderID != Auth.auth().currentUser?.uid ? .leading : .trailing)
         .padding(message.senderID != Auth.auth().currentUser?.uid  ? .leading : .trailing)
         .padding(.horizontal, 10)
         .padding(.bottom, 3)
         .alert("Unable to Delete Post", isPresented: $error_alert, actions: {}, message: {Text("Please check your network connection")})

     }
   }

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        
        let message = MessageModel(id: "", senderID: "", receiverID: "", message: "Here", timestamp: Date(), messageChannelID: "")
        MessageBubble(message: message, ChannelID: "")
    }
}
