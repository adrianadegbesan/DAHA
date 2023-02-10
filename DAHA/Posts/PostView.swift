//
//  PostView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/28/23.
//

import SwiftUI
import Firebase

//Check for if owner in wrapper(list)

struct PostView: View {
    @State var post: PostModel
    @State var saved = false
    @State var reported = false
    
    @State private var selected : Bool = false
    @State private var buyNavigate : Bool = false
    @State var owner : Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                
                PosterInfoView(post: post)
                
                CategoryView(post: post, reported: $reported)
                
                PostDescriptionView(post: post)
                
                PostActionView(post: post, saved: $saved, owner: owner)
                    .layoutPriority(1)
            }
            
            Spacer()
            
            PostImageView(post: post)
            
            
            
            NavigationLink(destination: Test(), isActive: $buyNavigate){
                EmptyView()
            }
            
        } //HStack
        .frame(width: screenWidth * 0.902, height: screenHeight * 0.2)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color(hex: category_colors[post.category] ?? "000000"), lineWidth: 3)
                .shadow(color: colorScheme == .dark ? .white : .black, radius: 2, y: 0)
        )
        .background(colorScheme == .dark ? .black.opacity(0.95) : .white)
        .cornerRadius(20)
        .onTapGesture {
            LightFeedback()
            selected = true
        }
        .sheet(isPresented: $selected){
            PostModal(post: post, saved: $saved, reported: $reported, owner: owner)
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        let calendar = Calendar.current
        let startTime = calendar.date(byAdding: .day, value: -2, to: Date())
        let startTimestamp: Timestamp = Timestamp(date: startTime!)
        
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted, gave me alot of miles but kinda creaky sometimes", postedAt: startTimestamp, condition: "Good", category: "Bikes", price: "100", imageURLs: [], channel: "Stanford", savers: [], type: "")
        NavigationView{
            PostView(post: post, owner: false)
        }
    }
}
