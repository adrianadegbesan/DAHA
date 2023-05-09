//
//  PostModalCategoryIcon.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 4/30/23.
//

import SwiftUI
import Firebase

struct AnimatedCategoryIcon: View {
    @State var post: PostModel
    @State var tapped: Bool = false
    @State var currentColor: String = ""
    @State private var isAnimating: Bool = false
    @Environment(\.colorScheme) var colorScheme
    let lightColors = ["001685", "BB0F0F", "0FBB2A", "00C5D6", "D89000", "5400D3", "03A597", "C5BF03", "D400D8", "000000"]
    let darkColors = ["001685", "BB0F0F", "0FBB2A", "00C5D6", "D89000", "5400D3", "03A597", "C5BF03", "D400D8", "FFFFFF"]
    
    var body: some View {
            Text(Image(systemName: category_images[post.category] ?? "bag.fill"))
                .font(
                    .system(size:65, weight: .regular)
                )
                .foregroundColor( tapped ? Color(hex: currentColor) : (post.category == "General" && colorScheme == .dark) ? .white : Color(hex: category_colors[post.category] ?? "000000") )
                .opacity(isAnimating ? 0 : 1)
                .animation(.easeInOut(duration: 0.5), value: isAnimating)
                .onTapGesture {
                        LightFeedback()
                        withAnimation {
                            isAnimating.toggle()
                            if !tapped {
                                tapped = true
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation {
                                currentColor = getNextColor()
                                isAnimating.toggle()
                            }
                        }
                }
                .onAppear{
                    if post.category == "General" && colorScheme == .dark {
                        currentColor = "FFFFFF"
                    } else {
                        currentColor = category_colors[post.category] ?? "000000"
                    }
                }
                
    }
    
    private func getNextColor() -> String {
        let colors = colorScheme == .dark ? darkColors : lightColors
       
        guard let currentIndex = colors.firstIndex(of: currentColor) else {
            return colors.first ?? ""
        }
        let nextIndex = (currentIndex + 1) % colors.count
        return colors[nextIndex]
    }
}

struct PostModalCategoryIcon_Previews: PreviewProvider {
    static var previews: some View {
        let calendar = Calendar.current
        let startTime = calendar.date(byAdding: .day, value: -27, to: Date())
        let startTimestamp: Timestamp = Timestamp(date: startTime!)
        
        let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted", postedAt: startTimestamp, condition: "old", category: "Bikes", price: "100", imageURLs: [], channel: "Stanford", savers: [], type: "", keywordsForLookup: [], reporters: [])
        
        AnimatedCategoryIcon(post: post)
    }
}
