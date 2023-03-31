//
//  DMScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI
import RefreshableScrollView
import Firebase

struct DMScreen: View {
    
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("username") var username_system: String = ""
    @AppStorage("unread") var unread: Bool = false
    @EnvironmentObject var messageManager : MessageManager
    @State var profile : Bool?
    @State var listener : ListenerRegistration?
    @State var isAnimating : Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            RefreshableScrollView{
                
                if profile == nil {
                    Spacer().frame(height: screenHeight * 0.01)
                }
                
                if profile != nil {
                    if !profile! {
                        Spacer().frame(height: screenHeight * 0.01)
                    }
                }
               
                
                if (messageManager.messageChannels.isEmpty && messageManager.messageChannelsLoading){
                    ProgressView()
                        .scaleEffect(1)
                } else if (messageManager.messageChannels.isEmpty && !messageManager.messageChannelsLoading){
                    if profile == nil{
                        Divider()
                        
                    }
                    Spacer().frame(height: 12)
                    
                    ZStack {
                        Image("Logo")
                            .opacity(colorScheme == .dark ? 0.75 : 0.9)
                            .overlay(Rectangle().stroke(.white, lineWidth: 2))
                            .scaleEffect(isAnimating ? 1.1 : 1.0)
                            .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1), value: isAnimating)
                            .onTapGesture{
                                 SoftFeedback()
                                 isAnimating = true
                                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    isAnimating = false
                                 }
                             }
                            .padding(.top, screenHeight * 0.15)
                      }
                    .frame(width: screenWidth)
                } else {
                    Divider()
                        .frame(maxHeight: 0.5)
                        .overlay(Color(hex: darkGrey))
                        .opacity(profile != nil ? (profile! ? 0 : 1) : 1)
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
                listener = messageManager.getMessageChannels()
            })
          
        }
        .background(colorScheme == .dark ? Color(hex: dark_scroll_background) : Color(hex: greyBackground))
        .onAppear{
            if unread {
                unread = false
            }
            UIApplication.shared.applicationIconBadgeNumber = 0
//            if messageManager.messageChannels.isEmpty{
//                listener = messageManager.getMessageChannels()
//            }
            withAnimation{
                messageManager.messageChannels.sort { $0.timestamp > $1.timestamp}
            }
        }
//        .onDisappear{
//            if listener != nil {
//                listener?.remove()
//            }
//        }
        .navigationTitle("DMs")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DMScreen_Previews: PreviewProvider {
    static var previews: some View {
        DMScreen()
            .environmentObject(MessageManager())
    }
}
