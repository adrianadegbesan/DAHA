//
//  ContentView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
  @AppStorage("onboarding") var isOnboardingViewActive: Bool = true
  @AppStorage("signedin") var isSignedIn: Bool = false
  @AppStorage("termsagreed") var agreedToTerms: Bool = false
  @AppStorage("university") var university: String = ""
  @AppStorage("username") var username_system: String = ""
  @AppStorage("email") var email_system: String = ""
  @AppStorage("emailverified") var verified: Bool = false
  @AppStorage("id") var user_id = ""
  @AppStorage("joined") var joinedAt = ""
  @AppStorage("notifications") var notifications : Bool = true
    
  @EnvironmentObject var authentication: AuthManager
  @EnvironmentObject var network: Network
  @EnvironmentObject var delegate: AppDelegate
  @EnvironmentObject var messagingManager : MessageManager

  @State private var opacity = 0.2
    
  @State private var shouldNavigate = false
  @State private var channel : MessageChannelModel? = nil
  @State var listener : ListenerRegistration?
  
    
  
  var body: some View {
    ZStack {
      
    
      if isOnboardingViewActive { /*Not Created Account*/
        SetUpScreen()
      } else if isSignedIn && !verified{ /* Email Not Verified */
        EmailScreen()
      } else if isSignedIn && verified && !agreedToTerms{ /*Not Agreed To Terms*/
        TermsConditionsScreen()
      } else if isSignedIn && verified && agreedToTerms{ 
         MainScreen()
          
          if channel != nil{
              NavigationLink( destination: ChatScreen(post: channel!.post, redirect: false, receiver: channel!.receiver == Auth.auth().currentUser?.uid ?? "" ? channel!.sender_username : channel!.receiver_username, receiverID:  channel!.receiver == Auth.auth().currentUser?.uid ?? "" ? channel!.sender : channel!.receiver, channelID: channel!.id, listen: true, scrollDown: true), isActive: $shouldNavigate){
                  EmptyView()
              }
          }
      }
    } //: ZStack
    .onAppear{
        if delegate.channelID_cur != "" {
            if isSignedIn && verified && agreedToTerms && delegate.shouldNavigate{
                Task {
                       print("\(delegate.channelID_cur)")
                       channel = await messagingManager.getChannel(channelID: delegate.channelID_cur)
                        if channel != nil{
                            print("not nil")
                        } else {
                            print("nil")
                        }
                        if channel != nil {
                            let success = await messagingManager.getMessagesOneTime(channelID: channel!.id)
                            if success{
                                 delegate.shouldNavigate = false
                                 delegate.channelID_cur = ""
                                 shouldNavigate = true
                            }
                        }
                }
            }
        }
    }
    .onChange(of: delegate.channelID_cur){ value in
        if delegate.channelID_cur != "" {
            if isSignedIn && verified && agreedToTerms && delegate.shouldNavigate{
                let curId = value
                Task {
                       print("\(delegate.channelID_cur)")
                       channel = await messagingManager.getChannel(channelID: curId)
                        if channel != nil{
                            print("not nil")
                        } else {
                            print("nil")
                        }
                        if channel != nil {
                            let success = await messagingManager.getMessagesOneTime(channelID: channel!.id)
                            if success{
                                 delegate.shouldNavigate = false
                                 delegate.channelID_cur = ""
                                 shouldNavigate = true
                            }
                        }
                }
            }
        }
    }
    .opacity(opacity)
    .onAppear{
        withAnimation(.easeIn(duration: 0.15)){
            self.opacity = 1
        }
    }
  }


}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
          .previewLayout(.sizeThatFits)
          .environmentObject(Network())
  }
}

