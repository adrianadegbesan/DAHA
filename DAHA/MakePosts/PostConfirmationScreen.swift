//
//  PostConfirmationScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/7/23.
//

import SwiftUI

struct PostConfirmationScreen: View {
    @Binding var post: PostModel
    @Binding var images: [UIImage]
    @Binding var post_created: Bool
    @State private var shouldNavigate : Bool = false
    @State private var uploading : Bool = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    @State private var progressOpacity : Double = 0
    @State private var screenOpacity : Double = 1
    
    var body: some View {
        ZStack {
            ProgressView()
                .opacity(progressOpacity)
                .scaleEffect(2.5)
            VStack{
                Spacer()
                
                Image("Logo")
                    .overlay(Rectangle().stroke(colorScheme == .dark ? .white : .clear, lineWidth: 2))
                    .padding(.bottom, 25)
                
                Text("By posting on DAHA you certify that this post is in accordance with all the rules and guidelines stated in the terms and conditions")
                    .font(
                        .system(size:17, weight: .heavy)
                    )
                    .foregroundColor(.gray)
                
                    .padding()
                
                NavigationLink(destination: MainScreen().navigationBarBackButtonHidden(true), isActive: $shouldNavigate){
                    EmptyView()
                }
                    Text("Violations of any of these rules may result in a permanent suspension of your account")
                        .font(
                            .system(size:14, weight: .heavy)
                        )
                        .foregroundColor(.red.opacity(0.9))
                Spacer().frame(height: screenHeight * 0.3)
                
                MakePostButton(post: $post, images: $images, post_created: $post_created, uploading: $uploading).onChange(of: post_created){ value in
                    if post_created {
                        dismiss()
                    }
                }
                .overlay(Capsule().stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
                
                .padding(.bottom, 20)
                    
            }
            .opacity(screenOpacity)
        }.onChange(of: uploading) { value in
            if uploading {
                screenOpacity = 0.5
                progressOpacity = 1
            } else if !uploading {
                screenOpacity = 1
                progressOpacity = 0
            }
        }
    }
}

struct PostConfirmationScreen_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted, gave me alot of miles but kinda creaky sometimes", postedAt: nil, condition: "Good", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "")
        let images: [UIImage] = []
        PostConfirmationScreen(post: .constant(post), images: .constant(images), post_created: .constant(false))
    }
}
