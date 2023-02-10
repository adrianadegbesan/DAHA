//
//  DeleteButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/1/23.
//

import SwiftUI

struct DeleteButton: View {
    @State var post: PostModel
    
    var body: some View {
        Button(action: {
            //DELETE DOCUMENT
            //REFRESH FEED
            
        }){
            Image(systemName: "trash")
                .font(.system(size: 23, weight: .bold))
                .foregroundColor(.red)
        }
        //ALERT
    }
}

struct DeleteButton_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "")
        DeleteButton(post: post)
    }
}
