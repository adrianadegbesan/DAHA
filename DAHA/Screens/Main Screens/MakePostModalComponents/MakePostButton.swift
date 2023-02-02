//
//  MakePostButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/31/23.
//

import SwiftUI

struct MakePostButton: View {
    
    @Binding var post : PostModel
    var body: some View {
        Button(action:{
            
        }){
            ZStack{
                Capsule().fill(Color(hex: deepBlue))
                    .frame(width: 68, height: 30)
                    .offset(y: -7)
                Text("Post")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 14)
            }
        }
    }
}

struct MakePostButton_Previews: PreviewProvider {
    static var previews: some View {
        let post: PostModel = PostModel(title: "", userID: "", username: "", description: "", condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [])
        MakePostButton(post: .constant(post))
    }
}