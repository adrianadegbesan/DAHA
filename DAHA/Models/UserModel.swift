//
//  User.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/8/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift


struct UserModel: Identifiable, Codable {
    var id: String?
    var username: String?
    var email: String?
    var firstname: String?
    var lastname: String?
    var channels: [String?]
    var university: String?
    var terms: Bool?
    @ServerTimestamp var joinedAt: Timestamp?
}
