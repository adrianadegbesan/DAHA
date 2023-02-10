//
//  MakePostModal.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/31/23.
//

import SwiftUI

struct MakePostScreen: View {
    
    @State var post: PostModel = PostModel(id: nil, title: "", userID: "", username: "", description: "", postedAt: nil, condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [], type: "")
    
    @State var images: [UIImage] = []
    @State var post_created: Bool = false
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        ScrollViewReader { value in
            ScrollView {
                VStack{
                    ChooseCategoryButton(post: $post)
                        .padding(.bottom, 10)
                    ConditionNavigatorView(post: $post)
                        .padding(.bottom, 10)
                    ItemTypeView(post: $post)
                        .padding(.bottom, 10)
                    MakePostTextInputs(post: $post)
                        .padding(.bottom, 10)
                    ImageSelectorView(images: $images)
                        .padding(.leading, 15)
                        .onChange(of: images){ image in
                            if images.isEmpty{
                                withAnimation{
                                    value.scrollTo(1, anchor: .top)
                                }
                            }
                        }
                    Spacer()
                }
                .padding()
                .id(1)
                
            }
            .onChange(of: post_created) { value in
                if post_created {
                    dismiss()
                }
            }
            .navigationBarBackButtonHidden(true)

            .navigationBarItems(leading: MakePostScreenExit(), trailing: NextButton(post: $post, images: $images, post_created: $post_created))
            
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

struct MakePostScreen_Previews: PreviewProvider {
    static var previews: some View {
        MakePostScreen()
    }
}
