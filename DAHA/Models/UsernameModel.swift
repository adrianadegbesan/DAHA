//
//  UsernameModel.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/9/23.
//

import Foundation
import SwiftUI


struct UsernameModel : Identifiable, Codable {
  var id: String
  var username: String
}


extension UsernameModel {
    var dictionaryRepresentation: [String:Any]{
        return [
            "id": self.id,
            "username": self.username
        ]
    }
}
