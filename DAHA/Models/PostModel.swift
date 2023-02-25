//
//  Post.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/8/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift


struct PostModel: Identifiable, Codable {
    var id: String
    var title: String
    var userID: String
    var username: String
    var description: String
    @ServerTimestamp var postedAt: Timestamp?
    var condition: String
    var category: String
    var price: String
    var imageURLs : [String]
    var channel: String
    var savers: [String]
    var type: String
    var keywordsForLookup : [String]
    var reporters : [String]
    
    init(id: String = UUID().uuidString, title: String, userID: String, username: String, description: String, postedAt: Timestamp? = nil, condition: String, category: String, price: String, imageURLs: [String], channel: String, savers: [String], type: String, keywordsForLookup: [String], reporters : [String]) {
        self.id = id
        self.title = title
        self.userID = userID
        self.username = username
        self.description = description
        self.postedAt = postedAt
        self.condition = condition
        self.category = category
        self.price = price
        self.imageURLs = imageURLs
        self.channel = channel
        self.savers = savers
        self.type = type
        self.keywordsForLookup = keywordsForLookup
        self.reporters = reporters
    }
}


