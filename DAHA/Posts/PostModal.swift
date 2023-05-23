//
//  PostModal.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI
import Firebase

struct PostModal: View {
    
    @Binding var post: PostModel
    @Binding var price: String
    @Binding var saved: Bool
    @Binding var reported: Bool
    @State var success_alert: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State var owner : Bool
    var body: some View {
        ScrollView {
            VStack(alignment: .leading){
                
                PostModalPosterInfo(post: post)
                
                CategoryView(post: post, screen: "Modal", reported: $reported, owner: owner, preview: false)
                    .padding(.leading, 12)
                    .padding(.trailing, 12)
                    
                
                PostModalDescription(post: post, price: $price, owner: owner)
                
                PostModalPostActions(post: $post, saved: $saved, price: $price, owner: owner)
                
                Spacer()
                
          
                
                
            }
            .padding()
            .navigationBarTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(.keyboard)
//            .navigationBarItems(leading: PostModalPosterInfo(post: post))
        }
        .alert("Successfully Reported Post", isPresented: $success_alert, actions:{}, message: {Text("This post was successfully reported")})
    }
}

struct PostModal_Previews: PreviewProvider {
    static var previews: some View {
        
        let calendar = Calendar.current
        let startTime = calendar.date(byAdding: .day, value: -27, to: Date())
        let startTimestamp: Timestamp = Timestamp(date: startTime!)
        
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: startTimestamp, condition: "old", category: "Bikes", price: "100", imageURLs: [], channel: "Stanford", savers: [], type: "", keywordsForLookup: [], reporters: [])
        PostModal(post: .constant(post), price: .constant(""), saved: .constant(false), reported: .constant(false), owner: true)
    }
}

// 2019 Giant Bike
