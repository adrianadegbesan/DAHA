//
//  MessageManager.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/11/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class MessageManager: ObservableObject {
    @AppStorage("university") var university: String = ""
    @AppStorage("username") var username_system: String = ""
     
    @Published var messageChannels : [MessageChannelModel] = []
    @Published var messageChannelsLoading : Bool = false
    
    @Published var messages: [String : [MessageModel]] = [:]
    @Published var messagesLoading : Bool = false
    
    let db = Firestore.firestore()
    
    init(){
        getMessageChannels()
        getMessages()
        
    }
    
    /*Function used to get current message channels, snapshot listener enabled*/
    
    func getMessageChannels() {
        messageChannelsLoading = true
        if Auth.auth().currentUser != nil{
            var temp: [MessageChannelModel] = []
            
            let id = Auth.auth().currentUser?.uid
            db.collection("Messages").whereField("users", arrayContains: id!).whereField("channel", isEqualTo: university).addSnapshotListener{ querySnapshot, error in
                guard let documents =  querySnapshot?.documents else {
                    print("error fetching documents:  \(String(describing: error))")
                    self.messageChannelsLoading = false
                    return
                }
                for document in documents{
                    do {
                        let channel = try document.data(as: MessageChannelModel.self)
                        temp.append(channel)
                    }
                    catch {
                        print("Error parsing channel: \(error.localizedDescription)")
                    }
                }
                
                temp.sort { $0.timestamp > $1.timestamp}
                
                withAnimation{
                    self.messageChannels.removeAll()
                    self.messageChannels = temp
                    self.messageChannelsLoading = false
                }
            }
            
        }
        
    }
    
    func getMessages() {
        messagesLoading = true
        if Auth.auth().currentUser != nil{
            var temp: [String: [MessageModel]] = [:]
            for channel in messageChannels {
                db.collection("Messages").document(channel.id).collection("messages").addSnapshotListener{ querySnapshot, error in
                    guard let documents = querySnapshot?.documents else {
                        print("error fetching documents:  \(String(describing: error))")
                        self.messagesLoading = false
                        return
                    }
                    
                    temp[channel.id] = []
                    
                    for document in documents {
                        
                        do {
                            let message = try document.data(as: MessageModel.self)
                            temp[channel.id]?.append(message)
                        }
                        catch{
                            print("Error parsing message: \(error.localizedDescription)")
                        }
                    }
                    
                    temp[channel.id]?.sort { $0.timestamp > $1.timestamp}
                    
                    withAnimation{
                        self.messages = temp
                        self.messagesLoading = false
                    }
                    
                }
            }
        }
    }
    
    
    func createMessageChannel(message: String, post: PostModel, channelID : Binding<String?>) async {
        let channel_id = UUID().uuidString
        
        if Auth.auth().currentUser != nil{
            let id = Auth.auth().currentUser!.uid
            let channel = MessageChannelModel(id: channel_id, sender: id, receiver: post.userID, users: [id, post.userID], post: post, timestamp: Date(), sender_username: username_system, receiver_username: post.username, channel: university)
            
            
            do {
                try await db.collection("Messages").document(channel.id).setData(from: channel)
                let parentRef = db.collection("Messages").document(channel.id)
                let message_sent = MessageModel(id: UUID().uuidString, senderID: id, receiverID: post.userID, message: message, timestamp: Date(), messageChannelID: channel.id)
                let subcollectionRef = parentRef.collection("messages").document(message_sent.id)
                try await subcollectionRef.setData(message_sent.dictionaryRepresentation)
                channelID.wrappedValue = channel_id
                return
            }
            catch {
                print(error.localizedDescription)
                return
            }
            
        }
        return
    }
    
    
    func sendMessage(message: String, channelID: String, post: PostModel, sent: Binding<Bool>) async {
        var success = false
        
        if Auth.auth().currentUser != nil{
            let id = Auth.auth().currentUser!.uid
            let message_sent = MessageModel(id: UUID().uuidString, senderID: id, receiverID: post.userID, message: message, timestamp: Date(), messageChannelID: channelID)
            do {
                try await db.collection("Messages").document(channelID).collection("messages").document(message_sent.id).setData(message_sent.dictionaryRepresentation)
                success = true
                sent.wrappedValue = success
//                let channelRef = db.collection("Messages").document(channelID)
//                try await channelRef.updateData(["timestamp": Date()])
                return
            }
            catch {
                print(error.localizedDescription)
                return
            }
        }
        return 
    }
    
    
    
}
