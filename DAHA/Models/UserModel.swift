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


/*
 Model for saving user data to firebase
 */
struct UserModel: Identifiable, Codable {
    var id: String
    var username: String
    var email: String
    var firstname: String
    var lastname: String
    var channels: [String]
    var university: String
    var terms: Bool
    var fcmToken : String
    @ServerTimestamp var joinedAt: Timestamp?
}


extension UserModel {
    var dictionaryRepresentation: [String:Any]{
        return [
                   "id": id,
                   "username": username,
                   "email": email,
                   "firstname": firstname,
                   "lastname": lastname,
                   "channels": channels,
                   "university": university,
                   "terms": terms,
                   "joinedAt": self.joinedAt != nil ? self.joinedAt! : FieldValue.serverTimestamp()
               ]
        }
}
