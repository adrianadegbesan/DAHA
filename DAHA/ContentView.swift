//
//  ContentView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI
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
    
  @EnvironmentObject var authentication: AuthManager
  @EnvironmentObject var network: Network

  @State private var opacity = 0.2
    
  
  var body: some View {
    ZStack {
      
      if isOnboardingViewActive {
        SetUpScreen()
//          EmailScreen()
      } else if isSignedIn && !verified{
        EmailScreen()
      } else if isSignedIn && verified && !agreedToTerms{
        TermsConditionsScreen()
      } else if isSignedIn && verified && agreedToTerms{
         MainScreen()
      }
    } //: ZStack
    .opacity(opacity)
    .onAppear{
        withAnimation(.easeIn(duration: 0.3)){
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

