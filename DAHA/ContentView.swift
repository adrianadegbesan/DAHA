//
//  ContentView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

struct ContentView: View {
  @AppStorage("onboarding") var isOnboardingViewActive: Bool = true
  @AppStorage("signedin") var isSignedIn: Bool = false
  @AppStorage("termsagreed") var agreedToTerms: Bool = false
  @AppStorage("university") var university: String = ""
  @AppStorage("username") var username_system: String = ""
  @AppStorage("email") var email_system: String = ""
    
  @EnvironmentObject var authentication: AuthManager
  
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
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
          .previewLayout(.sizeThatFits)
  }
}

