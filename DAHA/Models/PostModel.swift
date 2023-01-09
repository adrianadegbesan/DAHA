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
    @DocumentID var id: String?
    var title: String?
    var userID: String?
    var description: String?
    @ServerTimestamp var postedAt: Timestamp?
    var condition: String?
    var category: String?
    var price: String?
    var imageURLs : [String?]
    var channel: String?
}


