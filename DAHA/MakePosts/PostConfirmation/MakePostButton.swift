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
    @Binding var uploading: Bool
    @State private var error_alert: Bool = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var firestoreManager : FirestoreManager
    @EnvironmentObject var network: Network
    
    
    var body: some View {
        Button(action:{
            if !(uploading || post_created){
                MediumFeedback()
                network.checkConnection()
                Task {
                    if network.connected {
                        withAnimation {
                            uploading = true
                        }
                        if images.isEmpty {
                            try await Task.sleep(nanoseconds: 1_000_000_000)
                        }
                        
                        let result = await firestoreManager.makePost(post: post, images: images, post_created: $post_created)
                        
                        if !result{
                            error_alert = true
                        }
                    } else {
                        error_alert = true
                    }
                   
                    withAnimation{
                        uploading = false
                    }
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
        let post: PostModel = PostModel(title: "", userID: "", username: "", description: "", condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [], type: "", keywordsForLookup: [], reporters: [])
        let images : [UIImage] = []
        MakePostButton(post: .constant(post), images: .constant(images), post_created: .constant(false), uploading: .constant(false))
            .environmentObject(FirestoreManager())
    }
}
