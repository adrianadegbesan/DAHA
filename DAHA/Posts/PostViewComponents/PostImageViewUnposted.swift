//
//  PostImageViewUnposted.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 5/3/23.
//

import SwiftUI

struct PostImageViewUnposted: View {
    @Binding var post: PostModel
    @State var owner : Bool
    @State var preview: Bool
    @State var reported: Bool
    @State private var opacity: Double = 0.1
    @Environment(\.colorScheme) var colorScheme
    @State private var showImagePopup : Bool = false
    @State var unpostedImages : [UIImage]?
    
    var body: some View {
        
        if unpostedImages != nil && !unpostedImages!.isEmpty{
            TabView {
                
                Group {
                    if getValidAspectRatio(image: unpostedImages![0]) {
                        Image(uiImage: unpostedImages![0])
                            .resizable()
                            .cornerRadius(15)
                            .clipped()
                    } else {
                        Image(uiImage: unpostedImages![0])
                            .resizable()
                            .aspectRatio(contentMode:.fit)
                            .clipped()
                    }
                }
                
                    
                
            } //: TAB
            .tabViewStyle(PageTabViewStyle())
            .cornerRadius(15)
            .frame(width: screenWidth * 0.385, height: 175)
            .overlay (
                RoundedRectangle(cornerRadius: 15)
                    .strokeBorder(lineWidth: colorScheme == .dark ? 2 : 2)
                    .foregroundColor(colorScheme == .light ? .gray : .gray)
            )
            .clipped()
        } else {
            ZStack(alignment: .topTrailing){
                Image(systemName: category_images[post.category] ?? "bag.fill")
                    .scaleEffect(3)
                    .frame(width: screenWidth * 0.385, height: 175)
                    .foregroundColor( (post.category == "General" && colorScheme == .dark) ? .white : Color(hex: category_colors[post.category] ?? "000000") )
                    .overlay (
                        RoundedRectangle(cornerRadius: 15)
                            .strokeBorder(lineWidth: colorScheme == .dark ? 2 : 2)
                            .foregroundColor(colorScheme == .light ? .gray : .gray)
                    )
            }
        }
    }
}
