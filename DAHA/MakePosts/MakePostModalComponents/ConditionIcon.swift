//
//  ConditionIcon.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/31/23.
//

import SwiftUI

struct ConditionIcon: View {
    
    @Binding var post: PostModel
    @State var condition : String
    @Binding var selected : String
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        if (selected == condition){
            Button(action: {
                withAnimation{
                    SoftFeedback()
                    selected = ""
                    post.condition = ""
                }
            }) {
                Text(condition.uppercased())
                    .lineLimit(1)
//                    .foregroundColor(.blue)
                    .foregroundColor(condition == "New" ? Color(hex: color_new) : ((condition == "Good") ? Color(hex: color_good) : Color(hex: color_wornout)))
                    .font(.system(size: 10, weight: .bold))
                    .padding(10)
//                    .background(Capsule().stroke(.blue, lineWidth: 5))
                    .background(Capsule().stroke(condition == "New" ? Color(hex: color_new) : ((condition == "Good") ? Color(hex: color_good) : Color(hex: color_wornout)), lineWidth: 5))
                    .padding(.trailing, 10)
            }
            .buttonStyle(.plain)
            
        } else {
            Button(action: {
                withAnimation{
                    SoftFeedback()
                    selected = condition
                    post.condition = condition
                }
            }) {
                Text(condition.uppercased())
                    .lineLimit(1)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .font(.system(size: 10, weight: .bold))
                    .padding(10)
                    .background(Capsule().stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
                    .padding(.trailing, 10)
            }
            .buttonStyle(.plain)
            
        }

    }
}

struct ConditionIcon_Previews: PreviewProvider {
    static var previews: some View {
        let post: PostModel = PostModel(title: "", userID: "", username: "", description: "", condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [], type: "", keywordsForLookup: [], reporters: [])
        
        ConditionIcon(post: .constant(post), condition: "Good", selected: .constant("Good"))
    }
}
