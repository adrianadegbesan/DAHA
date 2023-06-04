//
//  PostActionView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/29/23.
//

import SwiftUI

struct PostActionView: View {
    
    @Binding var post: PostModel
    @Binding var saved: Bool
    @Binding var price: String
    @State var owner: Bool
    @State var preview: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack{
            HStack(spacing: 2){
                (Text((post.price == "Free" || post.price == "Sold" || post.price == "Satisfied") ? "" : "$") + Text(post.price))
    //            (Text((price == "Free" || price == "Sold" || price == "Satisfied") ? "" : "$") + Text(price))
                    .lineLimit(1)
                    .font(.system(size: 16, weight: .bold))
                    .layoutPriority(1)
                    .foregroundColor((post.price == "Sold" || post.price == "Satisfied") ? Color(hex: color_new) : .primary)
                if post.price == "Sold" || post.price == "Satisfied"{
                    Text(Image(systemName: "checkmark"))
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(hex: color_new))
                }
            }
            
            
            if owner && !preview{
                Spacer()
//                SoldButton(post: post, price: $price)
//                    .padding(.trailing, 1)
                if (post.price != "Sold" && post.price != "Satisfied"){
                    SoldButton(post: $post, price: $price)
                        .padding(.trailing, 1)
                }
                DeleteButton(post: post)
                
            } else if preview && !owner {
                
                Spacer()
                
                Text(post.type.uppercased())
                    .lineLimit(1)
                    .font(.system(size: 18, weight: .bold))
                    .padding(.trailing, 5)
                    .layoutPriority(1)
                    .foregroundColor((colorScheme == .dark && post.category == "General") ? .white : Color(hex: category_colors[post.category] ?? "000000"))
                    .modifier(shimmerOnTap())
                
            } else {
                if (post.price != "Sold" && post.price != "Satisfied"){
                    BuyButton(post: post)
                        .layoutPriority(1)
                }

                Spacer()
                BookmarkButton(post: post, saved: $saved)
            }
        }
//        .onAppear{
//            price = post.price
//        }
    }
}

struct PostActionView_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "100", imageURLs: [], channel: "Stanford", savers: [], type: "Request", keywordsForLookup: [], reporters: [])
        PostActionView(post:.constant(post) , saved: .constant(false), price: .constant(""), owner: true, preview: false)
            .environmentObject(FirestoreManager())
    }
}
