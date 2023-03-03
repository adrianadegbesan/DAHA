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
                
                temp.sort { $0.timestamp < $1.timestamp}
                
                withAnimation{
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
//                        let message = self.convertToMessage(doc: document)
//                        temp[channel.id]?.append(message)
                    }
                    
                    temp[channel.id]?.sort { $0.timestamp < $1.timestamp }
                    
                    withAnimation{
                        self.messages = temp
                        self.messagesLoading = false
                    }
                    
                }
            }
        }
    }
    
//    func convertToMessageChannel(doc: QueryDocumentSnapshot) -> MessageChannelModel {
//        let data = doc.data()
//        let result = MessageChannelModel(id: data["id"] as? String ?? "",
//                                         sender: data["sender"] as? String ?? "",
//                                         receiver: data["receiver"] as? String ?? "",
//                                         users: data["users"] as? [String] ?? [],
//                                         post: convertToPost(data["post"]) as? PostModel? ?? nil,
//                                         timestamp: data["timestamp"] as? Date ?? Date.now,
//                                         sender_username: data["sender_username"] as? String ?? "",
//                                         receiver_username: data["receiver_username"] as? String ?? "",
//                                         channel: data["channel"] as? String ?? "")
//        return result
//
//    }
    
//    func convertToMessage(doc : QueryDocumentSnapshot) -> MessageModel {
//        let data = doc.data()
//        let result = MessageModel(id: data["id"] as? String ?? "",
//                                  senderID: data["senderID"] as? String ?? "",
//                                  receiverID: data["receiverID"] as? String ?? "",
//                                  message: data["message"] as? String ?? "",
//                                  timestamp: data["timestamp"] as? Date ?? Date.now,
//                                  messageChannelID: data["messageChannelID"] as? String ?? "")
//        return result
//    }
    
    func createMessageChannel(message: String, post: PostModel) -> String?{
        var success = false
        var channel_made = false
        let channel_id = UUID().uuidString
        
        if Auth.auth().currentUser != nil{
            let id = Auth.auth().currentUser!.uid
            let channel = MessageChannelModel(id: channel_id, sender: id, receiver: post.userID, users: [id, post.userID], post: post, timestamp: Date(), sender_username: username_system, receiver_username: post.username, channel: university)
            
            do {
                try db.collection("Messages").document(channel.id).setData(from: channel){ err in
                    if let err = err{
                        print("\(err)")
                    } else{
                        channel_made = true
                    }
                }
                if channel_made {
                    let message_sent = MessageModel(id: UUID().uuidString, senderID: id, receiverID: post.userID, message: message, timestamp: Date(), messageChannelID: channel.id)
                    try db.collection("Messages").document(channel.id).collection("messages").document(message_sent.id).setData(from: message_sent){ err in
                        if let err = err{
                            print("\(err)")
                        } else{
                            success = true
                        }
                        
                    }
                }
            }
            catch {
                print(error.localizedDescription)
                success = false
                return nil
            }
            
        }
        if success{
            return channel_id
        } else {
            return nil
        }
    }
    
    func sendMessage(message: String, channelID: String, post: PostModel) -> Bool{
        var success = false
        
        if Auth.auth().currentUser != nil{
            let id = Auth.auth().currentUser!.uid
            let message_sent = MessageModel(id: UUID().uuidString, senderID: id, receiverID: post.userID, message: message, timestamp: Date(), messageChannelID: channelID)
            do {
                try db.collection("Messages").document(channelID).collection("messages").document(message_sent.id).setData(from: message_sent){ err in
                    if let err = err{
                        print("\(err)")
                    } else{
                        success = true
                    }
                }
//                let channelRef = db.collection("Messages").document(channelID)
//                try await channelRef.updateData(["timestamp": Date()])
                
                
            }
            catch {
                print(error.localizedDescription)
                return success
            }
        }
        return success
    }
    
    
    
}
