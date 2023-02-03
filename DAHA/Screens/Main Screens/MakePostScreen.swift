//
//  MakePostModal.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/31/23.
//

import SwiftUI

struct MakePostScreen: View {
    
    @State var post: PostModel = PostModel(title: "", userID: "", username: "", description: "", condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [])
    
    @State var images: [UIImage] = []
    
    
    var body: some View {
        ScrollView {
            VStack{
                ChooseCategoryButton(post: $post)
                    .padding(.bottom, 10)
                ConditionNavigatorView(post: $post)
                    .padding(.bottom, 10)
                MakePostTextInputs(post: $post)
                    .padding(.bottom, 10)
                ImageSelectorView(images: $images)
                    .padding(.leading, 15)
        
                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: MakePostScreenExit(), trailing: MakePostButton(post: $post))
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct MakePostScreen_Previews: PreviewProvider {
    static var previews: some View {
        MakePostScreen()
    }
}
