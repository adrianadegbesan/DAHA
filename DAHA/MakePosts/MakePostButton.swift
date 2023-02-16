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
    @Binding var post_created: Bool
//    @State var post_temp: Bool = false
    @Binding var uploading: Bool
    @State private var error_alert: Bool = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var firestoreManager : FirestoreManager
    
    
    var body: some View {
        Button(action:{
            if !(uploading || post_created){
                MediumFeedback()
                uploading = true
                Task {
                    try await Task.sleep(nanoseconds: 1_000_000_000)
                    await firestoreManager.makePost(post: post, images: images, post_created: $post_created) { error in
                        if error != nil{
                            error_alert = true
                            print(error!.localizedDescription)
                        }
                    }
                   
//                    if post.type == "Listing"{
//                        await firestoreManager.getListings()
//                    } else if post.type == "Request"{
//                        await firestoreManager.getRequests()
//                    }
                    
                    uploading = false
                    
//                    if post_temp {
//                        post_created = true
//                    }
                }
            }
            
        }){
            ZStack{
                Text("Post")
                    .font(.system(size: 18, weight: .heavy))
                    .padding()
                    .foregroundColor(.white)
                    .background(Capsule().fill(Color(hex: deepBlue)))
            }
        }
        .alert("Error Uploading Post", isPresented: $error_alert, actions: {}, message: {Text("Please check your network connection and try again later")})
    }
}
struct MakePostButton_Previews: PreviewProvider {
    static var previews: some View {
        let post: PostModel = PostModel(title: "", userID: "", username: "", description: "", condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [], type: "", keywordsForLookup: [])
        let images : [UIImage] = []
        MakePostButton(post: .constant(post), images: .constant(images), post_created: .constant(false), uploading: .constant(false))
            .environmentObject(FirestoreManager())
    }
}
