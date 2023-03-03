//
//  DMScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI
import RefreshableScrollView

struct DMScreen: View {
    
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("username") var username_system: String = ""
    @EnvironmentObject var messageManager : MessageManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            RefreshableScrollView{
                Spacer().frame(height: screenHeight * 0.01)
                
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
                } else {
                    Divider()
                        .frame(maxHeight: 0.5)
                        .overlay(Color(hex: darkGrey))
                    VStack(spacing: 0){
                        ForEach(messageManager.messageChannels){ preview in
                            MessagePreview(channel: preview)
                            Divider()
                                .frame(maxHeight: 0.5)
                                .overlay(Color(hex: darkGrey))
                        }
                    }
                }
              
            }.refreshable(action: {
                messageManager.getMessageChannels()
            })
          
        }
        .onAppear{
            withAnimation{
                messageManager.messageChannels.sort { $0.timestamp > $1.timestamp}
            }
        }
        .navigationTitle("Direct Messages")
    }
}

struct DMScreen_Previews: PreviewProvider {
    static var previews: some View {
        DMScreen()
            .environmentObject(MessageManager())
    }
}
