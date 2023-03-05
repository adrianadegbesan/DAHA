//
//  ReportUserModel.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/5/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

/*
 Model for reporting a user
 */
struct ReportUserModel: Identifiable, Codable {
    var id: String
    var userID: String
    var reporterID: String
    var channelID: String
    var description: String
    @ServerTimestamp var reportedAt: Timestamp?
}
