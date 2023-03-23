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
                .font(.system(size: 9, weight: .bold))
                .layoutPriority(1)
                .foregroundColor(.white)
                .padding(10)
                .background(Capsule().fill(Color(hex: category_colors[post.category] ?? "000000")))
                .overlay(colorScheme == .dark ? Capsule().stroke(.white, lineWidth: 2) : Capsule().stroke(.black, lineWidth: 2))
                .padding(.trailing, 6)
            //            }
            
            if post.borrow != nil && post.type == "Request"{
                if post.borrow! && screen == "Modal"{
                    (Text(Image(systemName: type_images["Borrow"] ?? "")) + Text(" ") + Text("Borrow"))
                        .lineLimit(1)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Capsule().fill(.black))
                        .overlay(colorScheme == .dark ? Capsule().stroke(.white, lineWidth: 2) : Capsule().stroke(.black, lineWidth: 2))
                        .padding(.trailing, 10)
                }
            }
            
            
            Text(post.condition.uppercased())
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .font(.system(size: 9, weight: .bold))
                .padding(10)
                .background(Capsule().stroke(lineWidth: colorScheme == .dark ? 2 : 2.4))
                .padding(.trailing, 10)
            
            if post.borrow != nil && post.type == "Request"{
                if post.borrow! && screen != "Modal"{
                    Image(systemName: type_images["Borrow"] ?? "")
                        .font(.system(size: 15, weight: .bold))
//                        .foregroundColor((post.category == "General" && colorScheme == .dark) ? .white : Color(hex: category_colors[post.category] ?? (colorScheme == .dark ? "FFFFFF" : "000000") ))
                        
                        .padding(8)
                        .background(Circle().stroke(lineWidth: 2))
                        .foregroundColor(Color(hex: "F37A35"))
                    
                    
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
