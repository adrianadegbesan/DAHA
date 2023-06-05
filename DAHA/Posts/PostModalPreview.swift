//
//  PostModalPreview.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/31/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct PostModalPreview: View {
    @State var post: PostModel
    @State var price: String
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
//    @State var owner : Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading){
                
//                PostModalImageView(post: post)
                
                PostModalPosterInfo(post: $post)
                
                CategoryPreview(post: post, screen: "Modal", owner: (post.userID == Auth.auth().currentUser?.uid))
                    .padding(.leading, 12)
                    .padding(.trailing, 12)
                    
                
                PostModalDescription(post: $post, price: $price, owner: (post.userID == Auth.auth().currentUser?.uid))
//                
                HStack{
                    Text(post.postedAt?.dateValue().dateString() ?? "")
                        .minimumScaleFactor(0.5)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.leading, 15)
                    
                    Spacer()
                    
                }
                .padding(.bottom, 10)
                  
                Spacer()
                
            }
            .padding(10)
            .navigationBarTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//struct PostModalPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        PostModalPreview()
//    }
//}
