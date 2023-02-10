//
//  ItemTypeView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/9/23.
//

import SwiftUI

struct ItemTypeView: View {
    @Binding var post: PostModel
    @State var selected: String = ""
    
    let types = ["Listing", "Request"]
    
    var body: some View {
        HStack{
            ForEach(types, id: \.self){ type in
                TypeIcon(post: $post, selected: $selected, type: type)
                    .padding(.horizontal)
            }
        }

    }
}

struct ItemTypeView_Previews: PreviewProvider {
    static var previews: some View {
        let post: PostModel = PostModel(title: "", userID: "", username: "", description: "", condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [], type: "")
        
        ItemTypeView(post: .constant(post))
    }
}
