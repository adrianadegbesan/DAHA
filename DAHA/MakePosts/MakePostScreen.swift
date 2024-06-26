//
//  MakePostModal.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/31/23.
//

import SwiftUI

struct MakePostScreen: View {
    
    
    @State private var post: PostModel = PostModel(title: "", userID: "", username: "", description: "", postedAt: nil, condition: "", category: "", price: "", imageURLs: [], channel: "", savers: [], type: "", keywordsForLookup: [], reporters: [])
    @State private var images: [UIImage] = []
    @State private var post_created: Bool = false
    @Environment(\.presentationMode) var presentationMode
//    @Environment(\.dismiss) var dismiss
    @State private var category: String = ""
    @State private var type: String = ""
//    @State var post_alert: Bool = false
    
    
    var body: some View {
        ScrollViewReader { value in
            ScrollView {
                VStack{
                    
//                    PostView(post: post, owner: false, preview: true, unpostedPreview: true, unpostedImages: images)
//                        .padding(.bottom, 5)
//                        .padding(.top, 5)
                    
                    HStack{
                        ChooseCategoryButton(selected: $category)
                            .padding(.trailing, 4)
                        ChooseTypeButton(selected: $type)
                    }
                        .padding(.bottom, 20)
                    ConditionNavigatorView(post: $post)
                        .padding(.bottom, 25)
                    MakePostTextInputs(post: $post, type: $type)
                        .padding(.bottom, 25)
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
//                .onChange(of: category){ value in
//                    hideKeyboard()
//                }
//                .onChange(of: type){ value in
//                    hideKeyboard()
//                }
                
                
            }
//            .dismissKeyboardOnDrag()
//            .onAppear {
//                UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color(hex: deepBlue))
//                UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color(hex: "D1D0CE"))
//            }
            .onChange(of: post_created) { value in
                if post_created {
                    presentationMode.wrappedValue.dismiss()
                }
            }

            

            .navigationBarItems(trailing: NextButton(post: $post, images: $images, post_created: $post_created, category: $category, type: $type))
            
//            .onTapGesture {
//                hideKeyboard()
//            }
        }
    }
}
struct MakePostScreen_Previews: PreviewProvider {
    static var previews: some View {
        MakePostScreen()
    }
}
