//
//  ContentView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

struct ContentView: View {
  @AppStorage("onboarding") var isOnboardingViewActive: Bool = false
  @AppStorage("signedin") var isSignedIn: Bool = true
  @AppStorage("termsagreed") var agreedToTerms: Bool = true
  @AppStorage("university") var university: String = ""
  @AppStorage("username") var username_system: String = ""
  @AppStorage("email") var email_system: String = ""
    
  @EnvironmentObject var authentication: AuthManager
  @EnvironmentObject var network: Network

  @State private var opacity = 0.2
    
  
  var body: some View {
    ZStack {
      
      if isOnboardingViewActive {
        SetUpScreen()
      } else if isSignedIn && !agreedToTerms{
        TermsConditionsScreen()
      } else if isSignedIn && agreedToTerms{
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

