//
//  MakePostButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/31/23.
//

import SwiftUI

struct MakePostButton: View {
    
    @Binding var post : PostModel
    @Binding var images: [UIImage]
    @State private var uploading: Bool = false
    @State private var error_alert: Bool = false
    @Binding var post_created: Bool
    @Environment(\.dismiss) var dismiss
   
    @EnvironmentObject var firestoreManager : FirestoreManager
    
    
    var body: some View {
        Button(action:{
            if !(uploading){
                MediumFeedback()
                uploading = true
                Task {
                    await firestoreManager.makePost(post: post, images: images, post_created: $post_created) { error in
                        if error != nil{
                            error_alert = true
                            print(error!.localizedDescription)
                        }
                    }
                    uploading = false
                }
            }
            
        }){
            ZStack{
                Capsule().fill(Color(hex: deepBlue))
                    .frame(width: screenWidth * 0.15, height: screenHeight * 0.04)
                    .offset(y: -7)
                Text("Post")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 14)
            }
        }
        // ALERT
    }
}

struct MakePostButton_Previews: PreviewProvider {
    static var previews: some View {
        let post: PostModel = PostModel(title: "", userID: "", username: "", description: "", condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [])
        let images : [UIImage] = []
        MakePostButton(post: .constant(post), images: .constant(images), post_created: .constant(false))
    }
}
