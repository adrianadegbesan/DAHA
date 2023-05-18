//
//  PostModalDescription.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/31/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostModalDescription: View {
    @State var post: PostModel
    @State private var opacity = 0.1
    @State private var descriptionScroll : Bool = false
    @State private var tabIndex = 0
    @State  var owner: Bool
    @State private var error_alert = false
    
    @State var isAnimating : Bool = false
    @State var isAnimating2 : Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(post.title)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .font(.system(size: 19, weight: .bold))
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1), value: isAnimating)
                    .onLongPressGesture(minimumDuration: 0.8) {
                         isAnimating = true
                         DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isAnimating = false
                         }
                     }
                    
                   
                
                Spacer()
                
                (Text((post.price == "Free" || post.price == "Sold" || post.price == "Satisfied") ? "" : "$") + Text(post.price))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .font(.system(size: 16, weight: .bold))
                    .scaleEffect(isAnimating2 ? 1.2 : 1.0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1), value: isAnimating2)
                    .onLongPressGesture(minimumDuration: 0.5) {
                        isAnimating2 = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            isAnimating2 = false
                        }
                     }
                 
            } //:HStack
            .padding(.leading, 12)
            .padding(.trailing, 12)

            if !post.imageURLs.isEmpty {
                TabView(selection: $tabIndex){
                    
                    ForEach(post.imageURLs.indices, id: \.self) { i in
                        
                            
                            GeometryReader { proxy in
                                WebImage(url: URL(string: post.imageURLs[i]))
                                    .resizable()
                                    .placeholder{
    //                                    ProgressView()
                                        Image(systemName: category_images[post.category] ?? "bag.fill")
                                            .scaleEffect(4)
                                            .frame(width: screenWidth * 0.96, height: screenHeight * 0.35)
                                            .foregroundColor( (post.category == "General" && colorScheme == .dark) ? .white : Color(hex: category_colors[post.category] ?? "000000") )
                                            .overlay (
                                //                RoundedRectangle(cornerRadius: 15)
                                                Rectangle()
                                                    .strokeBorder(lineWidth: 2)
                                            )
                                    }
                                    .indicator(.activity)
                                    .scaledToFit()
                                    .clipped()
//                                    .opacity(opacity)
                                    .transition(.scale)
                                    .overlay (
                                        Rectangle()
                                            .strokeBorder(lineWidth: 2)
                                    )
//                                    .onAppear{
//                                        withAnimation(.easeIn(duration: 0.3)){
//                                            opacity = 1
//                                        }
//                                    }
                                    .padding(.horizontal)
                                    .modifier(ImageModifier(contentSize: CGSize(width: proxy.size.width, height: proxy.size.height)))
                                    .tag(i)
                                    .contextMenu{
                                        Button{
                                            saveImageToPhotoAlbum(url: URL(string: post.imageURLs[i])!, error_alert: $error_alert)
                                        } label: {
                                            Label("Save Photo", systemImage: "square.and.arrow.down")
                                        }
                                    }
                                    
                                   
                            } //: GeometryReader
                 
                      } //: LOOP
                    
                    
                } //: TAB
                .tabViewStyle(.page(indexDisplayMode: .never))
    //            .cornerRadius(15)
                .padding(2.3)
                .frame(width: screenWidth, height: screenHeight * 0.4)
                .clipped()
                .alert("Error Saving Photo", isPresented: $error_alert, actions: {}, message: {Text("Please check your network connection and try again later")})
                
                if post.imageURLs.count > 1{
                    HStack{
                        Spacer()
                        HStack{
                            ForEach(post.imageURLs.indices, id: \.self){ i in
                                ImageIndicator(index: $tabIndex, my_index: i)
                                    .padding(.trailing, 3)
                            }
                        }
//                        .padding(4)
//                        .overlay(Capsule().stroke(lineWidth: 2))
                        Spacer()
                    }
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                }

            } else {
                
                AnimatedCategoryIcon(post: post)
                    .frame(width: screenWidth * 0.96, height: screenHeight * 0.35)
                    .overlay (
        //                RoundedRectangle(cornerRadius: 15)
                        Rectangle()
                            .strokeBorder(lineWidth: 2.5)
                    )
                    
//                Image(systemName: category_images[post.category] ?? "bag.fill")
//                    .scaleEffect(4)
//                    .frame(width: screenWidth * 0.96, height: screenHeight * 0.35)
//                    .foregroundColor( (post.category == "General" && colorScheme == .dark) ? .white : Color(hex: category_colors[post.category] ?? "000000") )
//                    .overlay (
//        //                RoundedRectangle(cornerRadius: 15)
//                        Rectangle()
//                            .strokeBorder(lineWidth: 2.5)
//                    )
            }
            
            HStack {
              Text(post.description)
                .padding(.leading, 15)
                .multilineTextAlignment(.leading)
                .textSelection(.enabled)
                .padding(.bottom, 8)
                
                Spacer()
            }
//            .frame(width: screenWidth * 0.9)
        }
    }
}

struct PostModalDescription_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "100", imageURLs: [], channel: "Stanford", savers: [], type: "", keywordsForLookup: [], reporters: [])
        PostModalDescription(post: post, owner: false)
    }
}
