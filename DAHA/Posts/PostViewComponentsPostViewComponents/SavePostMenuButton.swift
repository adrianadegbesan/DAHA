//
//  SavePostMenuButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 5/19/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct SavePostMenuButton: View {
    @EnvironmentObject var firestoreManager : FirestoreManager
    @State var post: PostModel
    @Binding var saved: Bool
    @Binding var save_alert: Bool
    
    var body: some View {
        Button{
            Task{
                let result = await firestoreManager.savePost(post: post)
                if result {
                    await firestoreManager.getSaved()
                } else {
                    save_alert = true
                }
            }
            firestoreManager.saved_refresh = true
            withAnimation{
                let id = Auth.auth().currentUser?.uid
                if id != nil && !post.savers.contains(id!){
                    post.savers.append(id!)
                    saved.toggle()
                }
            }
            
        } label:{
            Label("Save Post", systemImage: "bookmark")
        }
    }
}

//struct SavePostMenuButton_Previews: PreviewProvider {
//    static var previews: some View {
//        SavePostMenuButton()
//    }
//}
