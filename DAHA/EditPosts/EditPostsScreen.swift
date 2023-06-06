//
//  EditPosts.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 6/4/23.
//

import SwiftUI
import Firebase

struct EditPostsScreen: View {
    
    @State var post: PostModel
    @Binding var originalPost: PostModel
    @State private var images: [UIImage] = []
//    @State private var post_edited: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @State private var category: String = ""
    @State private var type: String = ""
    
    @State private var progressOpacity = 0.0
    @State private var screenOpacity = 1.0
    @State private var uploading = false
    
    var body: some View {
        
        ZStack {
            
            if uploading{
                LottieView(name: colorScheme == .dark ? "DAHA-Loading_dark" : "DAHA-Loading")
                    .scaleEffect(0.35)
                    .opacity(progressOpacity)
                    .padding(.bottom, screenHeight * 0.13)
                    .zIndex(1)
                    .ignoresSafeArea(.keyboard)
            }
            
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
                            .padding(.bottom, 25)
                        ImageSelectorEditsView(post: $post, images: $images)
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
//                    .onChange(of: post_edited) { value in
//                        if post_edited {
//                            presentationMode.wrappedValue.dismiss()
//                        }
//                    }
                    .onAppear {
                        type = post.type
                        category = post.category
                    }
                    .navigationBarItems(trailing: EditButton(post: $post, originalPost: $originalPost, images: $images, uploading: $uploading, category: $category, type: $type))
                }
            }
            .opacity(screenOpacity)
        }
        .onChange(of: uploading) { value in
            //Uploading + Progress View Animation
            if uploading {
                withAnimation{
                    screenOpacity = 0.2
                    progressOpacity = 0.9
                }
            } else if !uploading {
                withAnimation {
                    screenOpacity = 1.0
                    progressOpacity = 0.0
                    
                }
            }
            
        }
    }
    struct EditPostsScreen_Previews: PreviewProvider {
        static var previews: some View {
            let calendar = Calendar.current
            let startTime = calendar.date(byAdding: .day, value: -2, to: Date())
            let startTimestamp: Timestamp = Timestamp(date: startTime!)
            
            let post = PostModel(id: "", title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted, gave me alot of miles but kinda creaky sometimes", postedAt: startTimestamp, condition: "Good", category: "Bikes", price: "100", imageURLs: [], channel: "Stanford", savers: [], type: "Listing", keywordsForLookup: [], reporters: [])
            
            

            EditPostsScreen(post: post, originalPost: .constant(post))
        }
    }
    
}
