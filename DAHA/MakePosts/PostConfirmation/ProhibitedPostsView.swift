//
//  ProhibitedPostsView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/29/23.
//

import SwiftUI

struct ProhibitedPostsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State private var scrolled : Bool = false
    @State var post: PostModel
    @State var images: [UIImage]
    
    @State private var isAnimating : Bool = false
    @State private var isAnimating2 : Bool = false
    @State private var isAnimating3 : Bool = false
    @State private var isAnimating4 : Bool = false
    @State private var isAnimating5 : Bool = false
    @State private var isAnimating6 : Bool = false
    
    var body: some View {
        
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: true){
                    
                    VStack{
                    
                    Spacer().frame(height: 8)
                                           
                   Image("Logo")
                       .overlay(Rectangle().stroke(colorScheme == .dark ? .white : .clear, lineWidth: 2))
                       .scaleEffect(isAnimating ? 1.05 : 1.0)
                       .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1), value: isAnimating)
                       .onLongPressGesture(minimumDuration: 0.5) {
                            SoftFeedback()
                            isAnimating = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                               isAnimating = false
                            }
                        }
                       .padding(.bottom, 10)
                        
                        PostView(post: post, owner: false, preview: true, unpostedPreview: true, unpostedImages: images)
                    
                   Text("By posting on DAHA, you acknowledge that this post is in compliance with our terms and conditions:")
                       .font(
                           .system(size: 14, weight: .bold)
                       )
                       .foregroundColor(.secondary)
                   
                       .padding()
                   
                   
                   VStack{
                       HStack{
                           Image(systemName: "fork.knife")
                               .font(.system(size: 35, weight: .bold))
                               .foregroundColor(.red)
                           // Use .alignmentGuide to align the view to the leading edge
                               .alignmentGuide(.leading, computeValue: { dimension in
                                   // Return the width of the image as the leading edge
                                   35
                               })
                               .scaleEffect(isAnimating2 ? 1.2 : 1.0)
                               .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1), value: isAnimating2)
                               .onLongPressGesture(minimumDuration: 0.5) {
                                   SoftFeedback()
                                   isAnimating2 = true
                                   DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                       isAnimating2 = false
                                   }
                               }
                               .padding(.horizontal, 10)
                           
                           Text("No Food or Beverages")
                               .font(.system(size: 18, weight: .semibold))
                               .alignmentGuide(.leading, computeValue: { dimension in
                                   // Return the width of the image + spacing + the width of the text as the leading edge
                                   35 + 10 + dimension.width
                               })
                           
                           Spacer()
                       }
                       
                       .padding(.horizontal)
                       .padding(.bottom)
                       
                       HStack{
                           Image(systemName: "person.fill")
                               .font(.system(size: 35, weight: .bold))
                               .scaleEffect(isAnimating3 ? 1.2 : 1.0)
                               .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1), value: isAnimating3)
                               .onLongPressGesture(minimumDuration: 0.5) {
                                    SoftFeedback()
                                    isAnimating3 = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                       isAnimating3 = false
                                    }
                                }
                               .foregroundColor(.red)
                               .padding(.horizontal, 10)
                           
                           Text("No Personal/Sensitive Information")
                               .font(.system(size: 18, weight: .semibold))
                               .alignmentGuide(.leading, computeValue: { dimension in
                                   // Return the width of the image + spacing + the width of the text as the leading edge
                                   35 + 12 + dimension.width
                               })
                           
                           Spacer()
                       }
                       .padding(.horizontal)
                       .padding(.bottom)
                       
                       HStack{
                           Image(systemName: "multiply")
                               .font(.system(size: 35, weight: .bold))
                               .foregroundColor(.red)
                               .scaleEffect(isAnimating4 ? 1.2 : 1.0)
                               .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1), value: isAnimating4)
                               .onLongPressGesture(minimumDuration: 0.5) {
                                    SoftFeedback()
                                    isAnimating4 = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                       isAnimating4 = false
                                    }
                                }
                               .padding(.horizontal, 10)
                           
                           Text("No Dangerous/Illegal Items or Substances")
                               .font(.system(size: 18, weight: .semibold))
                               .alignmentGuide(.leading, computeValue: { dimension in
                                   // Return the width of the image + spacing + the width of the text as the leading edge
                                   35 + 8 + dimension.width
                               })
                           
                           Spacer()
                       }
                       .frame(height: 50)
                       .padding(.horizontal)
                       .padding(.bottom)
                       
                       HStack{
                           Image(systemName: "person.fill.xmark")
                               .font(.system(size: 35, weight: .bold))
                               .foregroundColor(.red)
                               .scaleEffect(isAnimating5 ? 1.2 : 1.0)
                               .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1), value: isAnimating5)
                               .onLongPressGesture(minimumDuration: 0.5) {
                                    SoftFeedback()
                                    isAnimating5 = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                       isAnimating5 = false
                                    }
                                }

                               .padding(.horizontal, 10)
                           
                           Text("No Indecent Content")
                               .font(.system(size: 18, weight: .semibold))
                               .alignmentGuide(.leading, computeValue: { dimension in
                                   // Return the width of the image + spacing + the width of the text as the leading edge
                                   35 + 10 + dimension.width
                               })
                           
                           Spacer()
                       }
                       .padding(.horizontal)
                       .padding(.bottom)
                       
                       HStack{
                           Image(systemName: "x.circle")
                               .font(.system(size: 35, weight: .bold))
                               .foregroundColor(.red)
                               .scaleEffect(isAnimating6 ? 1.2 : 1.0)
                               .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1), value: isAnimating6)
                               .onLongPressGesture(minimumDuration: 0.5) {
                                    SoftFeedback()
                                    isAnimating6 = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                       isAnimating6 = false
                                    }
                                }

                               .padding(.horizontal, 10)
                           
                           Text("No Stolen Property")
                               .font(.system(size: 18, weight: .semibold))
                               .alignmentGuide(.leading, computeValue: { dimension in
                                   // Return the width of the image + spacing + the width of the text as the leading edge
                                   35 + 10 + dimension.width
                               })
                           
                           Spacer()
                       }
                       .padding(.horizontal)
                       .padding(.bottom)

                   }
                    
                    HStack {
                                               
                           Text("and all the other prohibited items stated in the terms and conditions.")
                               .id(2)
                               .font(.system(size: 12.5, weight: .bold))
                               .foregroundColor(.secondary)
                               .padding(.top, 10)
                               .padding(.horizontal, 20)
                           
                           Image(systemName: "arrow.down.circle")
                               .font(.system(size: 20, weight: .heavy))
                               .foregroundColor(.red)
                               .onTapGesture {
                                   SoftFeedback()
                                   withAnimation{
                                       if !scrolled{
                                           proxy.scrollTo(1)
                                           scrolled = true
                                       } else {
                                           proxy.scrollTo(2, anchor: .bottom)
                                           scrolled = false
                                       }
                                   }
                                                                       
                               }
                               .padding(.top, 10)
                               .padding(.trailing, 10)
                               
                       }
                       
                       Text("Recurrent violations of any these guidelines may lead to the indefinite suspension of your account.")
                               .id(1)
                               .font(
                                   .system(size:14, weight: .bold)
                               )
                               .foregroundColor(.red.opacity(0.9))
                               .padding()
                                                  
                                           
                               
                               // Your existing code goes here
                               
                           }
                       }
                   }

                   Divider()
                }
            }
        
}

//struct ProhibitedPostsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProhibitedPostsView()
//    }
//}
