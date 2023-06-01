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
    @State private var timestampString : String = ""
    @State private var delete_alert : Bool = false
    @State private var error_alert : Bool = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var messageManager : MessageManager
    @State var listener : ListenerRegistration?
    
    @State private var isAnimating: Bool = false
    @State private var dragOffset = CGSize.zero
//    @State var appeared: Bool = false
    
    var body: some View {
        
        NavigationLink( destination: ChatScreen(post: channel.post, redirect: false, receiver: channel.receiver == Auth.auth().currentUser?.uid ?? "" ? channel.sender_username : channel.receiver_username, receiverID:  channel.receiver == Auth.auth().currentUser?.uid ?? "" ? channel.sender : channel.receiver, channelID: channel.id, listen: true, scrollDown: true) ){
            ZStack(alignment: .trailing) {
//                
//                DeleteChatView(channel: channel)
//                    .offset(x: dragOffset.width < 0.0 ? dragOffset.width + 40 : 45)
                
                VStack{
                    HStack{
                        VStack(){
                            Text(Image(systemName: category_images[channel.post.category] ?? "bag.fill"))
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(colorScheme == .dark && channel.post.category == "General" ? .white : Color(hex: category_colors[channel.post.category] ?? "ffffff") )
                                .padding(15)
                                .background(
                                      Circle()
                                          .fill(
                                              LinearGradient(gradient: Gradient(colors: [
                                                  Color(hex:  category_colors[channel.post.category] ?? "ffffff").opacity(0.3),
                                                  Color(hex: category_colors[channel.post.category] ?? "ffffff").opacity(0.15)
                                              ]), startPoint: .top, endPoint: .bottom)
                                          )
                                  )
//                                .background(
//                                      Circle()
//                                          .fill(
//                                            colorScheme == .light ?
//                                              LinearGradient(gradient: Gradient(colors: [
//                                                  Color(hex:  category_colors[channel.post.category] ?? "ffffff").opacity(0.3),
//                                                  Color(hex: category_colors[channel.post.category] ?? "ffffff").opacity(0.15)
//                                              ]), startPoint: .top, endPoint: .bottom) :
//                                                LinearGradient(gradient: Gradient(colors: [
//                                                    Color(hex:  category_colors[channel.post.category] ?? "ffffff").opacity(0.4),
//                                                    Color(hex: category_colors[channel.post.category] ?? "ffffff").opacity(0.2)
//                                                ]), startPoint: .top, endPoint: .bottom)
//                                          )
//                                  )
                            
                                .overlay(
                                    Circle()
                                        .stroke(lineWidth: 2)
                                        .foregroundColor(colorScheme == .dark && channel.post.category == "General" ? .white : Color(hex: category_colors[channel.post.category] ?? "ffffff") )
                                )
                                .scaleEffect(isAnimating ? 1.1 : 1.0)
                                .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1), value: isAnimating)
                                .onTapGesture{
                                    if !isAnimating{
                                        SoftFeedback()
                                        isAnimating = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                           isAnimating = false
                                        }
                                    }
                                 }
                        }
                        .frame(width: 60)

    //                    .padding(.trailing, 2.5)
                        VStack(alignment: .leading){
                            HStack{
                                Text("@\(channel.receiver == Auth.auth().currentUser?.uid ?? "" ? channel.sender_username : channel.receiver_username)")
                                    .font(.system(size: 16, weight: .bold))
                                
                                Spacer()
                                
                                HStack(spacing: 4){
        //                            Spacer()
                                    Text(timestampString)
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                        .onAppear{
                                            timestampString = messagePreviewText(for: channel.timestamp)
        //                                    timestampString = channel.timestamp.timeAgoDisplay()
                                        }
                                    
                                    Text(Image(systemName: "chevron.right"))
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.secondary.opacity(0.8))
        //                                .padding(.leading, 3)
                                }
                                
                            }
                            
                            HStack{
                                Text(channel.post.title)
                                    .font(.system(size: 14, weight: .bold))
                                
                                Spacer()
                                
                                (Text(channel.post.price == "Free" ? "" : "$") + Text(channel.post.price) + Text("  ") + Text(Image(systemName: type_images[channel.post.type] ?? ""))
                                    .foregroundColor(channel.post.borrow != nil ? (channel.post.borrow! ? Color(hex: category_colors["Borrow"] ?? "000000") : Color(hex: deepBlue) ) : Color(hex: deepBlue))
                                )
                                    .font(.system(size: 14, weight: .bold))
                                    .lineLimit(1)
                            }
                            
                            HStack {
                                Text(messageManager.messages[channel.id]?.last?.message ?? "")
                                    .font(.system(size: 13, weight: .semibold))
                                    .lineLimit(2)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                    
                        Spacer()
                        
                    }
                    .padding(.vertical, 2)
                    .padding(.horizontal, 6)
                    
                    
                }
                
                .frame(width: screenWidth, height: 90)
                .offset(x: dragOffset.width)
//                .gesture(  // Handle the drag gesture
//                    DragGesture()
//                        .onChanged { value in
//                            // Adjust the offset as the user drags
//                                // For leading-aligned bubbles, allow dragging to the right
//                                if value.translation.width < 0 && value.translation.width > -75 {
//                                    withAnimation{
//                                        dragOffset = value.translation
//                                    }
//
//                                }
//                        }
////                        .onEnded { value in
////                            // Reset the offset when the user ends the drag
////                            withAnimation {
////                                dragOffset = .zero
////                            }
////                        }
//               )
            }
          
            
        }
        .foregroundColor(colorScheme == .dark ? .white : .black)
//        .buttonStyle(.plain)
//        .background(colorScheme == .dark ? Color(hex: dark_scroll_background) : Color(hex: light_scroll_background))
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
            .environmentObject(MessageManager())
    }
}



//HStack{
////                        Text(Image(systemName: category_images[channel.post.category] ?? "bag.fill"))
////                            .font(.system(size: 18, weight: .bold))
////                            .foregroundColor(colorScheme == .dark && channel.post.category == "General" ? .white : Color(hex: category_colors[channel.post.category] ?? "ffffff") )
//    Text(Image(systemName: type_images[channel.post.type] ?? ""))
//        .font(.system(size: 18, weight: .bold))
//        .foregroundColor(colorScheme == .dark && channel.post.category == "General" ? .white : Color(hex: category_colors[channel.post.category] ?? "ffffff") )
//
//    if channel.post.borrow != nil{
//        if channel.post.borrow! {
//            Text(Image(systemName: type_images["Borrow"] ?? ""))
//                .font(.system(size: 14, weight: .bold))
//                .padding(6)
//                .background(Circle().stroke(lineWidth: 2))
//                .foregroundColor(Color(hex: category_colors["Borrow"] ?? "000000"))
//        }
//    }
//}
