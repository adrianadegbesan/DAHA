//
//  TypeModal.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/9/23.
//

import SwiftUI

struct TypeModal: View {
    
    @Binding var post: PostModel
    @Binding var selected: String
    
    var body: some View {
        VStack{
            ModalCapsule()
                 .padding(.top, 10)
            Spacer().frame(height: screenHeight * 0.08)
             Text("Types")
                 .font(
                     .system(size:30, weight: .heavy)
                 )
             Spacer().frame(height: screenHeight * 0.08)
             TypeIcon(post: $post, selected: $selected, type: "Listing")
             Spacer().frame(height: screenHeight * 0.08)
             TypeIcon(post: $post, selected: $selected, type: "Request")
             Spacer()
            
        }
    }
}

struct TypeModal_Previews: PreviewProvider {
    static var previews: some View {
        let post: PostModel = PostModel(title: "", userID: "", username: "", description: "", condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [], type: "")
        TypeModal(post: .constant(post), selected: .constant(""))
    }
}
