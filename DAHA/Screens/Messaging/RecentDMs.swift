//
//  RecentDMs.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/22/23.
//

import SwiftUI
import RefreshableScrollView

struct RecentDMs: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var messageManager : MessageManager
    @AppStorage("username") var username_system: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Spacer().frame(height: screenHeight * 0.005)
            if (messageManager.messageChannels.isEmpty && messageManager.messageChannelsLoading){
                ProgressView()
                    .scaleEffect(1)
            } else if (messageManager.messageChannels.isEmpty && !messageManager.messageChannelsLoading){
                ZStack {
                    Image("Logo")
                        .opacity(0.75)
                        .overlay(Rectangle().stroke(.white, lineWidth: 2))
                        .padding(.top, screenHeight * 0.15)
                  }
                .frame(width: screenWidth)
            } else{
                
                RefreshableScrollView{
                    
                    VStack(spacing: 0){
                        Divider()
                            .frame(maxHeight: 0.5)
                            .overlay(Color(hex: darkGrey))
                        
                        if messageManager.messageChannels.count < 5{
                            ForEach(messageManager.messageChannels){ preview in
                                MessagePreview(channel: preview)
                                Divider()
                                    .frame(maxHeight: 0.5)
                                    .overlay(Color(hex: darkGrey))
                            }
                        } else {
                            ForEach(0..<5, id: \.self){ i in
                                MessagePreview(channel: messageManager.messageChannels[i])
                                Divider()
                                    .frame(maxHeight: 0.5)
                                    .overlay(Color(hex: darkGrey))
                            }
                        }
                        
                    } //VStack
                    
                }.refreshable(action: {
                   let _ = messageManager.getMessageChannels()
                }) //ScrollView
            } //else
          
        }
    }
}

struct RecentDMs_Previews: PreviewProvider {
    static var previews: some View {
        RecentDMs()
            .environmentObject(MessageManager())
    }
}
