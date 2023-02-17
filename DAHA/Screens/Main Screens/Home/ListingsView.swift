//
//  ListingsView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/16/23.
//

import SwiftUI

struct ListingsView: View {
    @EnvironmentObject var firestoreManager : FirestoreManager
    
    var body: some View {
        VStack{
            PostScrollView(posts: $firestoreManager.listings, loading: $firestoreManager.listings_loading, screen: "Listings", query: .constant(""), type: .constant(""), category: .constant(""))
        }
    }
}

struct ListingsView_Previews: PreviewProvider {
    static var previews: some View {
        ListingsView()
    }
}
