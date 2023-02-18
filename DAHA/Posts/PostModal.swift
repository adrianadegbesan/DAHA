//
//  PostModal.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI
import Firebase

struct PostModal: View {
    
    @State var post: PostModel
    @Binding var saved: Bool
    @Binding var reported: Bool
    @Environment(\.dismiss) private var dismiss
    @State var owner : Bool
    var body: some View {
        ScrollView {
            VStack(alignment: .leading){
                PostModalActions()
                
                PostModalPosterInfo(post: post)
                
                
                CategoryView(post: post, reported: $reported, owner: owner, preview: false)
                    .padding(.leading, 12)
                    .padding(.trailing, 12)
                
                PostModalDescription(post: post, saved: $saved, owner: owner)
                  
                Spacer()
            }
            .padding()
        }
    }
}

struct PostModal_Previews: PreviewProvider {
    static var previews: some View {
        
        let calendar = Calendar.current
        let startTime = calendar.date(byAdding: .day, value: -27, to: Date())
        let startTimestamp: Timestamp = Timestamp(date: startTime!)
        
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: startTimestamp, condition: "old", category: "Bikes", price: "100", imageURLs: [], channel: "Stanford", savers: [], type: "", keywordsForLookup: [])
        PostModal(post: post, saved: .constant(false), reported: .constant(false), owner: true)
    }
}

// 2019 Giant Bike
