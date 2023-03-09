//
//  FirebaseHelpers.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/9/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

func deleteCollection(collectionRef: CollectionReference) {
    collectionRef.getDocuments() { querySnapshot, error in
        if let error = error {
            print("Error deleting subcollection: \(error)")
            return
        } else {
            for document in querySnapshot!.documents {
                document.reference.delete()
            }
            print("Subcollection deleted successfully!")
        }
    }
}
