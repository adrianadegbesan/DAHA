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

