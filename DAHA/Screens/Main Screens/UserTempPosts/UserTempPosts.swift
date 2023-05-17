//
//  UserTempPosts.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 5/16/23.
//

import SwiftUI

struct UserTempPosts: View {
    @State var userId : String
    @EnvironmentObject var firestoreManager : FirestoreManager
    var body: some View {
        VStack{
            PostScrollView(posts: $firestoreManager.user_temp_posts, loading: $firestoreManager.user_temp_posts_loading, screen: "UserTemp", query: .constant(""), type: .constant(""), category: .constant(""), userId: userId)
        }
//        .ignoresSafeArea()
    }
}

//struct UserTempPosts_Previews: PreviewProvider {
//    static var previews: some View {
//        UserTempPosts()
//    }
//}
