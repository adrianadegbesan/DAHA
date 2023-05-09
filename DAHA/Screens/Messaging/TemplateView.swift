//
//  TemplateView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 5/9/23.
//

import SwiftUI

struct TemplateView: View {
    @State var post: PostModel
    @Binding var message: String
    @Binding var channelID: String?
    @Binding var showTemplate: Bool
    
    var body: some View {
        VStack{
            
            if channelID == nil{
                if showTemplate{
                    if post.type == "Listing"{
                        if post.borrow != nil{
                            if post.borrow! == true{
                                TemplateMessage(text: "Hey \(post.username), I'd like to borrow this from you ", message: $message)
                            } else {
                                TemplateMessage(text: "Hey \(post.username), I'd like to buy this from you ", message: $message)
                            }
                        } else {
                            TemplateMessage(text: "Hey \(post.username), I'd like to buy this from you ", message: $message)
                        }
                        TemplateMessage(text:"Would it be possible to get this for ", message: $message)
                    } else {
                        if post.borrow != nil{
                            if post.borrow! == true{
                                TemplateMessage(text: "Hey \(post.username), I'm willing to lend this to you ", message: $message)
                            } else {
                                TemplateMessage(text: "Hey \(post.username), I have what you're looking for ", message: $message)
                            }
                        } else {
                            TemplateMessage(text: "Hey \(post.username), I have what you're looking for ", message: $message)
                        }
                        TemplateMessage(text:"I have this and would be fine with giving it to you for ", message: $message)
                    }
                   
                }
            }
        }
        .padding(.horizontal, 7)
        .onChange(of: message){ value in
            if message == "" {
                withAnimation(.easeIn(duration: 0.34)){
                    showTemplate = true
                }
            } else {
                withAnimation(.easeIn(duration: 0.34)){
                    showTemplate = false
                }
            }
            
        }

    }
}

//struct TemplateView_Previews: PreviewProvider {
//    static var previews: some View {
//        TemplateView()
//    }
//}
