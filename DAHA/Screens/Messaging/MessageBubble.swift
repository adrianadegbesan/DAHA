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
    @State private var error_alert : Bool = false
    @State private var dragOffset : CGFloat = 0.0
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var messageManager : MessageManager
    
    @State private var show: Bool = false
    @EnvironmentObject var appState : AppState
    @State private var opacity: CGFloat = 0.0
    
    var body: some View {
        
        
        VStack(alignment: message.senderID != Auth.auth().currentUser?.uid ?? "" ? .leading : .trailing) {
            
            ZStack(alignment: message.senderID != Auth.auth().currentUser?.uid ?? "" ? .leading : .trailing){
                
                if show {
                    if message.senderID != Auth.auth().currentUser?.uid {
                         TimestampView(message: message)
                            .offset(x: dragOffset != 0.0 && dragOffset > 0.0 ? dragOffset - 65 : -80)  // Move it with the bubble
                            .transition(.opacity)
                     }
                    if message.senderID == Auth.auth().currentUser?.uid {
                        TimestampView(message: message)
                            .offset(x: dragOffset != 0.0 && dragOffset < 0.0 ? dragOffset + 65 : 80)  // Move it with the bubble
                            .transition(.opacity)
                    }
                }
              
                
                HStack {
                    Text(message.message)
                        .font(message.message.containsOnlyEmoji && message.message.count <= 3 ? .largeTitle : .body)
//                        .scaleEffect(message.message.containsOnlyEmoji && message.message.count <= 3 ? 2 : 1)
                        .foregroundColor(colorScheme == .dark ? .white : (message.senderID != Auth.auth().currentUser?.uid ? .black : .white))
                        .padding(13)
                        .background(message.senderID != Auth.auth().currentUser?.uid ? Color(hex: colorScheme == .dark ? messageBubbleReceiver_dark : messageBubbleReceiver_light) : Color(hex: messageSender))
                        .cornerRadius(25)
                        .onTapGesture {
                            if dragOffset > 0 || dragOffset < 0{
                                withAnimation{
                                    show = false
                                    dragOffset = 0.0
                                }
                            }
                        }
                    
   //                     .contextMenu {
   //                         Button {
   //                            UIPasteboard.general.string = message.message
   //                         } label:{
   //                             Label("Copy", systemImage: "doc.on.doc")
   //                         }
   //                     }
                }
                .frame(maxWidth: 245, alignment: message.senderID != Auth.auth().currentUser?.uid  ? .leading : .trailing)
                .offset(x: dragOffset, y: 0)
                .highPriorityGesture(  // Handle the drag gesture
                    DragGesture()
                        .onChanged { value in
                            show = true
                            // Adjust the offset as the user drags
                            if message.senderID != Auth.auth().currentUser?.uid {
                                // For leading-aligned bubbles, allow dragging to the right
                                if value.translation.width > 0 && value.translation.width < 85 {
                                    withAnimation{
                                        dragOffset = value.translation.width
                                    }
                                   
                                }
                            } else {
                                // For trailing-aligned bubbles, allow dragging to the left
                                if value.translation.width < 0 && value.translation.width > -85 {
                                    withAnimation{
                                        dragOffset = value.translation.width
                                    }
                                }
                            }
                        }
                        .onEnded { value in
                            // Reset the offset when the user ends the drag
                            withAnimation {
                                show = false
                                dragOffset = 0.0
//                                forceRefresh.toggle()
                            }
                        }
               )
                .onChange(of: show){ value in
                    if !show {
                        dragOffset = 0.0
                    }
                    
                }
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
