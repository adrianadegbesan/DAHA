//
//  CategoryView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/29/23.
//

import SwiftUI
import Shimmer

struct CategoryView: View {
    
    @Binding var post: PostModel
    @State var screen: String
    @Binding var reported: Bool
    @State var owner: Bool
    @State var preview : Bool
    @State private var isAnimating1: Bool = false
    @State private var isAnimating2: Bool = false
    @State private var isAnimating3: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack{
            
            if screen == "Modal"{
                (Text(Image(systemName: category_images[post.category] ?? "")) + Text(" ") + Text(post.category.uppercased()))
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                    .font(.system(size: screen == "Modal" ? 9.5 : 9, weight: .bold))
                    .layoutPriority(1)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Capsule().fill(Color(hex: category_colors[post.category] ?? "000000")))
                    .overlay(colorScheme == .dark ? Capsule().stroke(.white, lineWidth: 2) : Capsule().stroke(.black, lineWidth: 2))
                    .scaleEffect(isAnimating1 ? 1.2 : 1.0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1), value: isAnimating1)
                    .onLongPressGesture(minimumDuration: 0.5) {
                            SoftFeedback()
                            isAnimating1 = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                isAnimating1 = false
                            }
                     }
                    .padding(.trailing, 6)
            } else {
                (Text(Image(systemName: category_images[post.category] ?? "")) + Text(" ") + Text(post.category.uppercased()))
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                    .font(.system(size: screen == "Modal" ? 9.5 : 9, weight: .bold))
                    .layoutPriority(1)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Capsule().fill(Color(hex: category_colors[post.category] ?? "000000")))
                    .overlay(colorScheme == .dark ? Capsule().stroke(.white, lineWidth: 2) : Capsule().stroke(.black, lineWidth: 2))
                    .padding(.trailing, 6)
            }
            
            
            
            if screen == "Modal"{
                Text(post.condition.uppercased())
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                    .font(.system(size: screen == "Modal" ? 9.5 : 9, weight: .bold))
//                    .foregroundColor(post.condition == "New" ? Color(hex: color_new) : ((post.condition == "Good") ? Color(hex: color_good) : Color(hex: color_wornout)))
                    .padding(10)
//                    .background(Capsule().fill(post.condition == "New" ? Color(hex: "556B2F") : ((post.condition == "Good") ? Color(hex: "#DAA520") : Color(hex: "36454F"))))
                    .background(Capsule().stroke(lineWidth: colorScheme == .dark ? 2 : 2.4))
//                    .background(Capsule().stroke(post.condition == "New" ? Color(hex: color_new) : ((post.condition == "Good") ? Color(hex: color_good) : Color(hex: color_wornout)), lineWidth: colorScheme == .dark ? 2 : 2.4))
                    .scaleEffect(isAnimating2 ? 1.2 : 1.0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1), value: isAnimating2)
                    .onLongPressGesture(minimumDuration: 0.5) {
                            SoftFeedback()
                            isAnimating2 = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                isAnimating2 = false
                            }
                     }
                    .padding(.trailing, 10)
            } else {
                Text(post.condition.uppercased())
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                    .font(.system(size: screen == "Modal" ? 9.5 : 9, weight: .bold))
//                    .foregroundColor(post.condition == "New" ? Color(hex: color_new) : ((post.condition == "Good") ? Color(hex: color_good) : Color(hex: color_wornout)))
                    .padding(10)
//                    .background(Capsule().fill(post.condition == "New" ? Color(hex: "556B2F") : ((post.condition == "Good") ? Color(hex: "DAA520") : Color(hex: "36454F"))))
                    .background(Capsule().stroke(lineWidth: colorScheme == .dark ? 2 : 2.4))
//                    .background(Capsule().stroke(post.condition == "New" ? Color(hex: color_new) : ((post.condition == "Good") ? Color(hex: color_good) : Color(hex: color_wornout)),lineWidth: colorScheme == .dark ? 2 : 2.4))
                    .padding(.trailing, 10)
            }
           
            
            if post.borrow != nil{
                
                if post.borrow! {
                    
                    if screen != "Modal" {
                        Image(systemName: type_images["Borrow"] ?? "")
                            .font(.system(size: 15, weight: .bold))
                            .padding(8)
                            .background(Circle().stroke(lineWidth: 2))
                            .foregroundColor(Color(hex: category_colors["Borrow"] ?? "000000"))
                            .modifier(shimmerOnTap())
                    }
                  
                    
                    if screen == "Modal"{
                        
                        (Text(Image(systemName: type_images["Borrow"] ?? "")) + Text(" ") + Text(post.type == "Request" ? "Borrow" : "Lend"))
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Color(hex: category_colors["Borrow"] ?? "000000"))
                            .padding(10)
                            .background(Capsule().stroke(Color(hex: category_colors["Borrow"] ?? "000000"), lineWidth: 2))
                            .scaleEffect(isAnimating3 ? 1.2 : 1.0)
                            .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1), value: isAnimating3)
                            .onLongPressGesture(minimumDuration: 0.5) {
                                    SoftFeedback()
                                    isAnimating3 = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                        isAnimating3 = false
                                    }
                                }
                    }
                    
                }
                
            }
            
            Spacer()
            
            if !owner && !preview && screen == "Modal"{
                ReportButton(post: post, reported: $reported)
            }
        }
        .scaleEffect((post.condition == "Worn-Out" && post.borrow != nil && screen != "Modal") ? (post.borrow! ? 0.85 : 1) : 1)
        .offset(x: (post.condition == "Worn-Out" && post.borrow != nil && screen != "Modal") ? (post.borrow! && post.category.count <= 5 ? -8 : 0): 0)
        .offset(x: (post.condition == "Good" && post.borrow != nil && screen != "Modal") ? (post.borrow! && post.category.count > 5 ? 6 : 0): 0)
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: nil, condition: "old", category: "Bikes", price: "$100", imageURLs: [], channel: "Stanford", savers: [], type: "", keywordsForLookup: [], reporters: [])
        CategoryView(post: .constant(post), screen: "Modal", reported: .constant(false), owner: false, preview: false)
    }
}
