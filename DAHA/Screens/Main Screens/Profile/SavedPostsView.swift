//
//  SavedPostsView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/16/23.
//

import SwiftUI

struct SavedPostsView: View {
    @EnvironmentObject var firestoreManager : FirestoreManager
    var body: some View {
        VStack {
            PostScrollView(posts: $firestoreManager.saved_posts, loading: $firestoreManager.saved_loading, screen: "Saved", query: .constant(""), type: .constant(""), category: .constant(""))
        }
    }
}

struct SavedPostsView_Previews: PreviewProvider {
    static var previews: some View {
        SavedPostsView()
    }
}
