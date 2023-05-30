//
//  SendMessageView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 5/30/23.
//

import SwiftUI

struct SendMessageView: View {
    @State var post: PostModel
    @State var receiver: String
    @Binding var channelID: String?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if channelID == nil {
            HStack{
                
                (Text("Send \(receiver) a message! ").foregroundColor(.secondary) + Text(Image(systemName: "paperplane"))
                    .foregroundColor(colorScheme == .dark && post.category == "General" ? .white : Color(hex: category_colors[post.category] ?? "000000")))
                    
                    .font(.system(size: 18, weight: .bold))
            }
        }
    }
}

//struct SendMessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        SendMessageView()
//    }
//}
