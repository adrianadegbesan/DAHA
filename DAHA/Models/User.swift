//
//  User.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/8/23.
//

import Foundation
import SwiftUI


struct User: Identifiable, Codable {
    let id: String?
    let username: String?
    let email: String?
    let firstname: String?
    let lastname: String?
    let channels: [String]?
}
