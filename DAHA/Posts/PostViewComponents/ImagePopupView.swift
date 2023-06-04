//
//  ImagePopupView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/8/23.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct ImagePopupView: View {
    @State var post: PostModel
    @State private var opacity = 0.1
    @State private var tabIndex = 0
    @State private var error_alert = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack{
            TabView(selection: $tabIndex){
                
                ForEach(post.imageURLs.indices, id: \.self) { i in
                    
                    ZStack{
                        
                        GeometryReader { proxy in
                            WebImage(url: URL(string: post.imageURLs[i]))
                                .resizable()
                                .placeholder{
                                    Image(systemName: category_images[post.category] ?? "bag.fill")
                                        .scaleEffect(4)
                                        .frame(width: screenWidth * 0.96, height: screenHeight * 0.35)
                                        .foregroundColor( (post.category == "General" && colorScheme == .dark) ? .white : Color(hex: category_colors[post.category] ?? "000000") )
                                        .overlay (
                            //                RoundedRectangle(cornerRadius: 15)
                                            Rectangle()
                                                .strokeBorder(lineWidth: 3)
                                        )
                                }
                                .indicator(.activity)
                                .scaledToFit()
                                .clipped()
                                .opacity(opacity)
                                .transition(.scale)
                                .overlay (
                                    Rectangle()
                                        .strokeBorder(lineWidth: 3)
                                )
                                .onAppear{
                                    withAnimation(.easeIn(duration: 0.3)){
                                        opacity = 1
                                    }
                                }
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
                    }
             
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
                    Spacer()
                }
                .padding(.top, 5)
                .padding(.bottom, 5)
            }

         }
        .padding()
        .cornerRadius(20)
        .frame(width: screenWidth * 0.6, height: screenHeight * 0.6)
      }
    }

struct ImagePopupView_Previews: PreviewProvider {
    static var previews: some View {
        let calendar = Calendar.current
        let startTime = calendar.date(byAdding: .day, value: -2, to: Date())
        let startTimestamp: Timestamp = Timestamp(date: startTime!)
        
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted, gave me alot of miles but kinda creaky sometimes", postedAt: startTimestamp, condition: "Good", category: "Bikes", price: "100", imageURLs: [], channel: "Stanford", savers: [], type: "Listing", keywordsForLookup: [], reporters: [])
        ImagePopupView(post: post)
    }
}
