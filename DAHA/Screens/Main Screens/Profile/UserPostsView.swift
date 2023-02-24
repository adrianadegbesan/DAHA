//
//  UserPostsView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/16/23.
//

import SwiftUI

struct UserPostsView: View {
    @EnvironmentObject var firestoreManager : FirestoreManager
    var body: some View {
        VStack{
            PostScrollView(posts: $firestoreManager.my_posts, loading: $firestoreManager.my_posts_loading, screen: "Profile", query: .constant(""), type: .constant(""), category: .constant(""))
        }
    }
}

struct UserPostsView_Previews: PreviewProvider {
    static var previews: some View {
        UserPostsView()
    }
}
