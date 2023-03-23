//
//  CategoryView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/29/23.
//

import SwiftUI

struct CategoryView: View {
    
    @State var post: PostModel
    @State var screen: String
    @Binding var reported: Bool
    @State var owner: Bool
    @State var preview : Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack{
            
            
            (Text(Image(systemName: category_images[post.category] ?? "")) + Text(" ") + Text(post.category.uppercased()))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .font(.system(size: screen == "Modal" ? 10 : 9, weight: .bold))
                .layoutPriority(1)
                .foregroundColor(.white)
                .padding(10)
                .background(Capsule().fill(Color(hex: category_colors[post.category] ?? "000000")))
                .overlay(colorScheme == .dark ? Capsule().stroke(.white, lineWidth: 2) : Capsule().stroke(.black, lineWidth: 2))
                .padding(.trailing, 6)
            //            }
            
      
            Text(post.condition.uppercased())
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .font(.system(size: screen == "Modal" ? 10 : 9, weight: .bold))
                .padding(10)
                .background(Capsule().stroke(lineWidth: colorScheme == .dark ? 2 : 2.4))
                .padding(.trailing, 10)
            
            if post.borrow != nil && post.type == "Request" {
                
                if post.borrow! {
                    
                    if screen != "Modal" {
                        Image(systemName: type_images["Borrow"] ?? "")
                            .font(.system(size: 15, weight: .bold))
                            .padding(8)
                            .background(Circle().stroke(lineWidth: 2))
                            .foregroundColor(Color(hex: "F37A35"))
                    }
                  
                    
                    if screen == "Modal"{
                        
                        (Text(Image(systemName: type_images["Borrow"] ?? "")) + Text(" ") + Text("Borrow"))
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(hex: "F37A35"))
                            .padding(10)
                            .background(Capsule().stroke(Color(hex: "F37A35"), lineWidth: 2))
                
                    }
                    
                }
                
            }
            
            Spacer()
            
            if !owner && !preview && screen == "Modal"{
                ReportButton(post: post, reported: $reported)
            }
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "", keywordsForLookup: [], reporters: [])
        CategoryView(post: post, screen: "Modal", reported: .constant(false), owner: false, preview: false)
    }
}
