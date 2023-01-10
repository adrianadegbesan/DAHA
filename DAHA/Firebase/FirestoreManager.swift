//
//  FirestoreManager.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/9/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreManager: ObservableObject {
    
    private var db = Firestore.firestore()
    
    func verifyDomain(domain: String, schoolFound: Binding<Bool>, cannot_verify: Binding<Bool>) async {
        var found: Bool = false
        print(domain)
        
        do {
            let snapshot = try await db.collection("Universities").whereField("Domain", isEqualTo: domain).getDocuments()
            found = !snapshot.isEmpty
            print(found)
            schoolFound.wrappedValue = found
        }
        catch {
            print("couldn't find")
            found = false
            cannot_verify.wrappedValue = true
        }
    
    }
}
