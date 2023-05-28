//
//  PostModalImageView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 5/28/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostModalImageView: View {
    @State var post: PostModel
    @State private var tabIndex = 0
    @State private var error_alert = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
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
                                        .strokeBorder(lineWidth: 1.5)
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
                    Rectangle()
                        .strokeBorder(lineWidth: 1.5)
                )
        }
    }
}

//struct PostModalImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostModalImageView()
//    }
//}
