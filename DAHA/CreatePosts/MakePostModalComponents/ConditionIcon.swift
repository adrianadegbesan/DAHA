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
    
    var body: some View {
        if (selected == condition){
            Button(action: {
                LightFeedback()
                selected = ""
                post.condition = ""
            }) {
                Text(condition.uppercased())
                    .lineLimit(1)
                    .foregroundColor(.blue)
                    .font(.system(size: 10, weight: .bold))
                    .padding(10)
                    .background(Capsule().stroke(.blue, lineWidth: 5))
                    .padding(.trailing, 10)
            }
            
        } else {
            Button(action: {
                LightFeedback()
                selected = condition
                post.condition = condition
            }) {
                Text(condition.uppercased())
                    .lineLimit(1)
                    .foregroundColor(.black)
                    .font(.system(size: 10, weight: .bold))
                    .padding(10)
                    .background(Capsule().stroke(.black, lineWidth: 2))
                    .padding(.trailing, 10)
            }
            
        }

    }
}

struct ConditionIcon_Previews: PreviewProvider {
    static var previews: some View {
        let post: PostModel = PostModel(title: "", userID: "", username: "", description: "", condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [])
        
        ConditionIcon(post: .constant(post), condition: "Good", selected: .constant("Good"))
    }
}
