//
//  ReportView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/29/23.
//

import SwiftUI

struct ReportButton: View {
    @State var post: PostModel
    @Binding var reported: Bool
    
    var body: some View {
        Image(systemName: "flag")
            .font(.system(size: 22, weight: .bold))
            .onTapGesture {
                //Report Action (2 Alerts)
            }
    }
}

struct ReportButton_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "", keywordsForLookup: [])
        
        ReportButton(post: post, reported: .constant(false))
    }
}
