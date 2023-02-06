//
//  BuyButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/29/23.
//

import SwiftUI

struct BuyButton: View {
    
    @State var post: PostModel
    @State private var shouldNavigate: Bool = false
    
    var body: some View {
        Button(action: {
            //MessagingAction
            LightFeedback()
            shouldNavigate = true
        }){
            HStack(spacing: 0){
                Text("BUY ")
                    .minimumScaleFactor(0.05)
                    .fixedSize(horizontal: true, vertical: false)
                    .font(.system(size: 14, weight: .bold))
                  
                    .layoutPriority(1)
                    .lineLimit(1)
                Image(systemName: "paperplane.fill")
                    .minimumScaleFactor(0.05)
                    .font(.system(size: 14, weight: .bold))
            
                
                NavigationLink(destination: Test(), isActive: $shouldNavigate){
                    EmptyView()
                }
                
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
//            .font(.system(size: 15, weight: .bold))
            .foregroundColor(.white)
            .background(Capsule().fill(Color(hex: deepBlue)))
            //ALERT
        }
    }
}

struct BuyButton_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [])
        BuyButton(post: post)
    }
}
