//
//  MessageModel.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/2/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift


struct MessageModel: Identifiable, Codable{
    var id: String
    var senderID: String
    var receiverID: String
    var message: String
    var timestamp : Date
    var messageChannelID : String
}

extension MessageModel {
    var dictionaryRepresentation: [String : Any]{
        return [
            "id": self.id,
            "senderID" : self.senderID,
            "receiverID" : self.receiverID,
            "message" : self.message,
            "timestamp" : self.timestamp,
            "messageChannelID" : self.messageChannelID
        ]
    }
}
