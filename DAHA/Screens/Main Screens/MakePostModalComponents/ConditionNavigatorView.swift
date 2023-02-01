//
//  ConditionNavigatorView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/31/23.
//

import SwiftUI

struct ConditionNavigatorView: View {
    
    @Binding var post: PostModel
    @State var selected: String = ""
    
    let conditions = ["New", "Good", "Broken"]
    
    var body: some View {
        HStack{
            ForEach(conditions, id: \.self){ condition in
                ConditionIcon(post: $post, condition: condition, selected: $selected)
                    .padding(.horizontal)
            }
        }
    }
}

struct ConditionNavigatorView_Previews: PreviewProvider {
    static var previews: some View {
        let post: PostModel = PostModel(title: "", userID: "", username: "", description: "", condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [])
        
        ConditionNavigatorView(post: .constant(post))
    }
}
