//
//  SavedPosts.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/8/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift


struct SavedPost: Identifiable, Codable {
    @DocumentID var id: String?
    var saverID: String?
    var postID: String?
    var title: String?
    var userID: String?
    var description: String?
    var postedAt: Timestamp?
    var condition: String?
    var category: String?
    var price: String?
    var imageURLs : [String]?
    var channel: String?
}
