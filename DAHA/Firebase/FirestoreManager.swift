//
//  FirestoreManager.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/9/23.
//

import Foundation
import SwiftUI
import Firebase

class FirestoreManager: ObservableObject {
    
    private var db = Firestore.firestore()
    
    func verifyDomain(domain: String) -> Bool {
        var found: Bool = false
        
        db.collection("Universities").whereField("Domain", isEqualTo: domain)
            .getDocuments() { (querySnapshot, err) in
                if err != nil {
                    found = false
                    print("Couldn't Find")
                } else {
                    found = true
                    
                }
            }
        
        return found
    }
}
