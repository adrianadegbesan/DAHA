//
//  MakePostModal.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/31/23.
//

import SwiftUI

struct MakePostScreen: View {
    
    @State var post: PostModel = PostModel(title: "", userID: "", username: "", description: "", postedAt: nil, condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [], type: "", keywordsForLookup: [])
    
    @State var images: [UIImage] = []
    @State var post_created: Bool = false
    @Environment(\.dismiss) var dismiss
    @State var category: String = ""
    @State var type: String = ""
//    @State var post_alert: Bool = false
    
    
    var body: some View {
        ScrollViewReader { value in
            ScrollView {
                VStack{
                    HStack{
                        ChooseCategoryButton(selected: $category)
                            .padding(.trailing, 4)
                        ChooseTypeButton(selected: $type)
                    }
                        .padding(.bottom, 20)
                    ConditionNavigatorView(post: $post)
                        .padding(.bottom, 25)
                    MakePostTextInputs(post: $post, type: $type)
                        .padding(.bottom, 20)
                    ImageSelectorView(images: $images)
                        .padding(.leading, 15)
                        .onChange(of: images){ image in
                            if images.isEmpty{
                                withAnimation{
                                    value.scrollTo(1, anchor: .top)
                                }
                            } else {
                                withAnimation{
                                    value.scrollTo(1, anchor: .bottom)
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
            .onAppear{
                print("post_created is \(post_created)! ")
//                if post_created{
//                    post_alert = true
//                }
            }
//            .alert("Post Created", isPresented: $post_alert, actions: {}, message: {Text("Your post was successfully created!")})
            .navigationBarBackButtonHidden(true)
            

            .navigationBarItems(leading: MakePostScreenExit(), trailing: NextButton(post: $post, images: $images, post_created: $post_created, category: $category, type: $type))
            
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
