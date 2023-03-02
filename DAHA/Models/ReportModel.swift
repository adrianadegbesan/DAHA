//
//  ReportModel.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/23/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

/*
 Model for reporting a post
 */
struct ReportModel: Identifiable, Codable {
    var id: String
    var postID: String
    var posterID: String
    var reporterID: String
    var description: String
    @ServerTimestamp var reportedAt: Timestamp?
}
