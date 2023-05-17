//
//  ViewPostsButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 5/16/23.
//

import SwiftUI

struct ViewPostsButton: View {
    @EnvironmentObject var firestoreManager : FirestoreManager
    @State var post: PostModel
    @Binding var userPostNavigate: Bool
    
    var body: some View {
        Button{
            firestoreManager.user_temp_posts.removeAll()
            Task {
                await firestoreManager.getUserTempPosts(userId: post.userID)
            }
            userPostNavigate = true
        } label: {
            Label("View \(post.username.capitalized)'s Posts", systemImage: "person.fill")
        }
    }
}

//struct ViewPostsButton_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewPostsButton()
//    }
//}
