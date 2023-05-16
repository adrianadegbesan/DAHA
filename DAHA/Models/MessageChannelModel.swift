//
//  MessageChannelModel.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/2/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift


/*
 Model for message channels
 */
struct MessageChannelModel: Identifiable, Codable{
    var id: String
    var sender: String
    var receiver: String
    var users: [String]
    var post: PostModel
    var timestamp: Date
    var sender_username : String
    var receiver_username : String
    var channel: String
}

extension MessageChannelModel{
    var dictionaryRepresentation: [String:Any]{
        return [
            "id" : self.id,
            "sender" : self.sender,
            "receiver" : self.receiver,
            "users" : self.users,
            "post" : self.post,
            "timestamp" : self.timestamp,
            "sender_username" : self.sender_username,
            "receiver_username" : self.receiver_username,
            "channel" : self.channel
        ]
    }

}

