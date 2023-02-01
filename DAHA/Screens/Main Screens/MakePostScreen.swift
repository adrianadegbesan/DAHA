//
//  MakePostModal.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/31/23.
//

import SwiftUI

struct MakePostScreen: View {
    
    @State var post: PostModel = PostModel(title: "", userID: "", username: "", description: "", condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [])
    
    @State var price : String = ""
    @State var title : String = ""
    @State var description : String = ""
    
    
    var body: some View {
        ScrollView {
            VStack{
                CategorySelectorView(post: $post)
                    .padding(.bottom, 10)
                ConditionNavigatorView(post: $post)
        
                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: MakePostScreenExit(), trailing: MakePostButton(post: $post))
    }
    
}

struct MakePostScreen_Previews: PreviewProvider {
    static var previews: some View {
        MakePostScreen()
    }
}
