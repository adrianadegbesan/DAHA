//
//  MessageOptions.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/3/23.
//

import SwiftUI
import Firebase

struct MessageOptions: View {
    
    @State var post: PostModel
    @State var channelID : String
    @State var username : String
    @State var receiverID: String
    @State private var delete_alert : Bool = false
    @State private var error_alert : Bool = false
    @State private var report_modal : Bool = false
    @State private var reported : Bool = false
    @Binding var shouldNavigate: Bool
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var messageManager : MessageManager
    
    var body: some View {
        
        ZStack{
            Menu{
                
                if #available(iOS 16, *){
                    Button {
                        shouldNavigate = true
                    } label: {
                        Label("Expand Post", systemImage: "arrowshape.right")
                    }
                } else {
                    Button {
                        shouldNavigate = true
                    } label: {
                        Label("Expand Post", systemImage: "arrow.right")
                    }
                }
               
                
                Button(role: .destructive){
                    report_modal = true
                } label:{
                    Label("Report User", systemImage: "flag")
                }
                
                Button(role: .destructive){
                    delete_alert = true
                    
                    
                } label:{
                    Label("Delete Chat", systemImage: "trash")
                }
                
            } label: {
                Label("", systemImage: "ellipsis.circle")
            }
            
            .foregroundColor(.primary)
            
            .sheet(isPresented: $report_modal){
                ReportUserModal(channelID: channelID, reported: $reported, username: username, receiverID: receiverID)
            }
            
            .onChange(of: reported){ value in
                if reported {
                    dismiss()
                    Task{
                        let success = await messageManager.deleteChat(channelID: channelID)
                        if success {
                            dismiss()
                        }
                    }
                }
            }
            
            .alert("Delete Chat", isPresented: $delete_alert, actions: {
                Button("Delete", role: .destructive, action: {
                    Task{
                        let result = await messageManager.deleteChat(channelID: channelID)
                        if !result{
                            error_alert = true
                        } else {
                            dismiss()
                        }
                    }
                })
                
                
            }, message: {Text("Are you sure you want to delete this chat?")})
            
            .alert("Unable to Delete Chat", isPresented: $error_alert, actions: {}, message: {Text("Please check your network connection and try again later.")})
            
//            NavigationLink(destination: PostModalPreview(post: post), isActive: $shouldNavigate){
//                EmptyView()
//            }
        }
        
        
    }
}

//struct MessageOptions_Previews: PreviewProvider {
//    static var previews: some View {
//        let calendar = Calendar.current
//        let startTime = calendar.date(byAdding: .day, value: -2, to: Date())
//        let startTimestamp: Timestamp = Timestamp(date: startTime!)
//        
//        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted, gave me alot of miles but kinda creaky sometimes", postedAt: startTimestamp, condition: "Good", category: "Bikes", price: "100", imageURLs: [], channel: "Stanford", savers: [], type: "Request", keywordsForLookup: [], reporters: [])
//        
//        let channel = MessageChannelModel(id: "", sender: "1", receiver: "2", users: ["1", "2"], post: post, timestamp: Date(), sender_username: "adrian", receiver_username: "john", channel: "Stanford")
//        
//        MessageOptions(post: post, channelID: channel.id, username: "adrian", receiverID: "")
//    }
//}
