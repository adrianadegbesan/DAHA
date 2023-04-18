//
//  SavedView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 4/18/23.
//

import SwiftUI

struct SavedView: View {
    @EnvironmentObject var firestoreManager : FirestoreManager
    var body: some View {
        VStack{
            PostScrollView(posts: $firestoreManager.saved_posts, loading: $firestoreManager.saved_loading, screen: "Saved", query: .constant(""), type: .constant(""), category: .constant(""))
        }
    }
}

struct SavedView_Previews: PreviewProvider {
    static var previews: some View {
        SavedView()
    }
}
