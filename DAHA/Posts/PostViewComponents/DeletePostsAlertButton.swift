//
//  DeletePostsAlertButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 5/19/23.
//

import SwiftUI

struct DeletePostsAlertButton: View {
    @EnvironmentObject var firestoreManager : FirestoreManager
    @State var post: PostModel
    @Binding var error_alert: Bool
    @Binding var deleted: Bool

    
    var body: some View {
        
        Button("Delete", role: .destructive, action: {
            Task{
                let delete_success = await firestoreManager.deletePost(post: post, deleted: $deleted, error_alert: $error_alert)

                if delete_success {

                    withAnimation{
                        if post.type == "Listing"{
                            if let index = firestoreManager.listings.firstIndex(where: { $0.id == post.id }) {
                                firestoreManager.listings.remove(at: index)
                            }


                        } else if post.type == "Request"{
                            if let index = firestoreManager.requests.firstIndex(where: { $0.id == post.id }) {
                                firestoreManager.requests.remove(at: index)
                            }
                        }
                          if let index = firestoreManager.my_posts.firstIndex(where: { $0.id == post.id }) {
                              firestoreManager.my_posts.remove(at: index)
                          }
                    }

                } else {
                    error_alert = true
                }
            }
        })
        .buttonStyle(.plain)
    }
}

//struct DeletePostsAlertButton_Previews: PreviewProvider {
//    static var previews: some View {
//        DeletePostsAlertButton()
//    }
//}
