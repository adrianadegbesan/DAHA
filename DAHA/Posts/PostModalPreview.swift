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
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
//    @State var owner : Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading){
                
                PostModalPosterInfo(post: post)
                
                CategoryPreview(post: post, screen: "Modal", owner: (post.userID == Auth.auth().currentUser?.uid))
                    .padding(.leading, 12)
                    .padding(.trailing, 12)
                    
                
//                PostModalDescription(post: post, owner: (post.userID == Auth.auth().currentUser?.uid))
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
            .padding()
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
