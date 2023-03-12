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
  @AppStorage("joined") var joinedAt = ""
  @AppStorage("notifications") var notifications : Bool = true
    
  @EnvironmentObject var authentication: AuthManager
  @EnvironmentObject var network: Network
  @EnvironmentObject var delegate: AppDelegate

  @State private var opacity = 0.2
    
  @State private var shouldNavigate = false
    
  
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
          
          NavigationLink(destination: Test(), isActive: $shouldNavigate){
              EmptyView()
          }
      }
    } //: ZStack
    .onAppear{
        if delegate.shouldNavigate{
            if isSignedIn && verified && agreedToTerms{
                delegate.shouldNavigate = false
                shouldNavigate = true
            }
        }
    }
    .onChange(of: delegate.shouldNavigate){ value in
        if delegate.shouldNavigate {
            if isSignedIn && verified && agreedToTerms{
                delegate.shouldNavigate = false
                shouldNavigate = true
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

