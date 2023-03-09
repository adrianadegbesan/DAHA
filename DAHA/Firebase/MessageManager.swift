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

@MainActor
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
    }
    
    /*Function used to get current message channels, snapshot listener enabled*/
    
    func getMessageChannels() {
//        messageChannelsLoading = true
        if Auth.auth().currentUser != nil{
//            var temp: [MessageChannelModel] = []
            
            let id = Auth.auth().currentUser?.uid
            db.collection("Messages").whereField("users", arrayContains: id!).whereField("channel", isEqualTo: university).addSnapshotListener{ querySnapshot, error in
                guard let documents =  querySnapshot?.documents else {
                    print("error fetching documents:  \(String(describing: error))")
                    return
                }
                for document in documents{
                    do {
                        let channel = try document.data(as: MessageChannelModel.self)
                        withAnimation{
                            if !(self.messageChannels.contains(where: { $0.id == channel.id })) {
                                self.messageChannels.append(channel)
                            } else {
                                let index = self.messageChannels.firstIndex(where: { $0.id == channel.id })
                                if index != nil {
                                    self.messageChannels.remove(at: index!)
                                    self.messageChannels.append(channel)
                                }
                            }
                            self.messageChannels.sort { $0.timestamp > $1.timestamp}
                        }
                    }
                    catch {
                        print("Error parsing channel: \(error.localizedDescription)")
                    }
                }
                
//                temp.sort { $0.timestamp > $1.timestamp}
//
//                withAnimation{
//                    self.messageChannels.removeAll()
//                    self.messageChannels = temp
//                    self.messageChannelsLoading = false
//                }
            }
            
        }
        
    }
    
    func getMessages(channelID : String) {
//        messagesLoading = true
        if Auth.auth().currentUser != nil{
            
            
            db.collection("Messages").document(channelID).collection("messages").addSnapshotListener{ querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("error fetching documents:  \(String(describing: error))")
//                    self.messagesLoading = false
                    return
                }
                
                for document in documents {
                    do {
                        let message = try document.data(as: MessageModel.self)
                        withAnimation{
                            if self.messages.keys.contains(channelID){
                                if !(self.messages[channelID]!.contains(where: { $0.id == message.id})){
                                    self.messages[channelID]?.append(message)
                                }
                            } else {
                                self.messages[channelID] = [message]
                            }
                            self.messages[channelID]?.sort { $0.timestamp < $1.timestamp}
                        }
                    }
                    catch{
                        print("Error parsing message: \(error.localizedDescription)")
                    }
                }
                
            }
        }
    }
    
    
    func createMessageChannel(message: String, post: PostModel, channelID : Binding<String?>, error_alert: Binding<Bool>) async -> Bool{
        let channel_id = UUID().uuidString
        
        if Auth.auth().currentUser != nil{
            let id = Auth.auth().currentUser!.uid
            let channel = MessageChannelModel(id: channel_id, sender: id, receiver: post.userID, users: [id, post.userID], post: post, timestamp: Date(), sender_username: username_system, receiver_username: post.username, channel: university)
            
            
            do {
                try db.collection("Messages").document(channel.id).setData(from: channel)
                let parentRef = db.collection("Messages").document(channel.id)
                let message_sent = MessageModel(id: UUID().uuidString, senderID: id, receiverID: post.userID, message: message, timestamp: Date(), messageChannelID: channel.id)
                let subcollectionRef = parentRef.collection("messages").document(message_sent.id)
                try await subcollectionRef.setData(message_sent.dictionaryRepresentation)
                channelID.wrappedValue = channel_id
                return true
            }
            catch {
                print(error.localizedDescription)
                error_alert.wrappedValue = true
                return false
            }
            
        }
        error_alert.wrappedValue = true
        return false
    }
    
    
    func sendMessage(message: String, channelID: String, post: PostModel, sent: Binding<Bool>, error_alert: Binding<Bool>) async -> Bool {
        
        
        if Auth.auth().currentUser != nil{
            let id = Auth.auth().currentUser!.uid
            let message_sent = MessageModel(id: UUID().uuidString, senderID: id, receiverID: post.userID, message: message, timestamp: Date(), messageChannelID: channelID)
            do {
                try await db.collection("Messages").document(channelID).collection("messages").document(message_sent.id).setData(message_sent.dictionaryRepresentation)
                sent.wrappedValue = true
                let channelRef = db.collection("Messages").document(channelID)
                try await channelRef.updateData(["timestamp": Date()])
                return true
            }
            catch {
                print(error.localizedDescription)
                error_alert.wrappedValue = true
                return false
            }
        }
        error_alert.wrappedValue = true
        return false
    }
    
    func deleteChat(channelID : String) async -> Bool{
        do {
            try await db.collection("Messages").document(channelID).delete()
           
            
            withAnimation{
                let channelIndex = messageChannels.firstIndex(where: {$0.id == channelID})
                if channelIndex != nil{
                    messageChannels.remove(at: channelIndex!)
                }
                if messages.keys.contains(channelID){
                    messages.removeValue(forKey: channelID)
                }
                getMessageChannels()
            }
            return true
        }
        catch {
            return false
        }
        
    }
    
    func deleteMessage(channelID : String, messageID : String) async -> Bool{
        do {
            try await db.collection("Messages").document(channelID).collection("messages").document(messageID).delete()
            
            withAnimation(.easeIn(duration: 0.3)){
                if self.messages.keys.contains(channelID){
                    let message_index = messages[channelID]!.firstIndex(where: {$0.id == messageID})
                    if message_index != nil{
                       _ = messages[channelID]!.remove(at: message_index!)
                    }
                }
            }
            return true
        }
            
        catch {
            return false
        }
    }
    
    func reportUser(report: ReportUserModel) -> Bool{
        let userId = Auth.auth().currentUser?.uid
        
        if userId == nil{
            return false
        }
        
        do {
            try db.collection("Universities").document("\(university)").collection("User-Reports").document(report.id).setData(from: report)
            return true
        }
        
        catch{
            print("error reporting posts")
            return false
        }
        
    }
    
    
    
    
}
