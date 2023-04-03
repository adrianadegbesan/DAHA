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
    @AppStorage("signedin") var isSignedIn: Bool = false
    @AppStorage("termsagreed") var agreedToTerms: Bool = false
     
    @Published var messageChannels : [MessageChannelModel] = []
    @Published var messageChannelsLoading : Bool = false
    
    @Published var messages: [String : [MessageModel]] = [:]
    @Published var messagesLoading : Bool = false
    
    let db = Firestore.firestore()
    
    init(){
        if isSignedIn && agreedToTerms {
            let _ = getMessageChannels()
        }
        
    }
    
    /*Function used to get current message channels, snapshot listener enabled*/
    
    func getChannel(channelID: String) async -> MessageChannelModel? {
        if Auth.auth().currentUser != nil{
            do {
                let snapshot = try await db.collection("Messages").document(channelID).getDocument()
                let channel = try snapshot.data(as: MessageChannelModel.self)
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
                    print("Found Channel!")
                }
                return channel
            }
            catch {
                print(error.localizedDescription)
                print("error retrieving channel")
                return nil
            }
            
        } else {
            return nil
        }
    }
    
    func getMessageChannels() -> ListenerRegistration?  {
//        messageChannelsLoading = true
        var listener : ListenerRegistration? = nil
        if Auth.auth().currentUser != nil{
//            var temp: [MessageChannelModel] = []
            
            let id = Auth.auth().currentUser?.uid
            listener = db.collection("Messages").whereField("users", arrayContains: id!).whereField("channel", isEqualTo: university).addSnapshotListener{ querySnapshot, error in
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
            }
            
        } else {
            return nil
        }
        return listener
    }
    
    func getMessagesOneTime(channelID : String ) async -> Bool{
        if Auth.auth().currentUser?.uid != nil{
            do {
                let snapshot = try await db.collection("Messages").document(channelID).collection("messages").getDocuments()
                let documents = snapshot.documents
                for document in documents{
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
                    catch {
                        return false
                    }
                }
                return true
                
            }
            catch {
                print("Error getting messages")
                return false
            }
            
        } else {
            print("Error getting messages")
            return false
        }
    }
    
    func getMessages(channelID : String) -> ListenerRegistration? {
        var listener : ListenerRegistration? = nil
        if Auth.auth().currentUser != nil{
            
            listener = db.collection("Messages").document(channelID).collection("messages").addSnapshotListener{ querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("error fetching documents:  \(String(describing: error))")
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
            return listener
            
        } else {
            return nil
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
    
    
    func sendMessage(message: String, channelID: String, post: PostModel, sent: Binding<Bool>, receiverID: String, error_alert: Binding<Bool>) async -> Bool {
        
        
        if Auth.auth().currentUser != nil{
            
            let id = Auth.auth().currentUser!.uid
            let message_sent = MessageModel(id: UUID().uuidString, senderID: id, receiverID: receiverID, message: message, timestamp: Date(), messageChannelID: channelID)
            do {
                try await db.collection("Messages").document(channelID).collection("messages").document(message_sent.id).setData(message_sent.dictionaryRepresentation)
                sent.wrappedValue = true
                let channelRef = db.collection("Messages").document(channelID)
                try await channelRef.updateData(["timestamp": Date()])
                
                let index = messageChannels.firstIndex(where: {$0.id == channelID})
                
                if index != nil{
                    messageChannels[index!].timestamp = Date()
                    messageChannels.sort { $0.timestamp > $1.timestamp}
                }
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
        
        let subRef = db.collection("Messages").document(channelID).collection("messages")
        do {
            try await db.collection("Messages").document(channelID).delete()
            deleteCollection(collectionRef: subRef)
           
            
            withAnimation{
                let channelIndex = messageChannels.firstIndex(where: {$0.id == channelID})
                if channelIndex != nil{
                    messageChannels.remove(at: channelIndex!)
                }
                if messages.keys.contains(channelID){
                    messages.removeValue(forKey: channelID)
                }
                let _ = getMessageChannels()
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
