//
//  OnboardingScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 3/27/23.
//

import SwiftUI

struct OnboardingScreen: View {
    
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
    
    var body: some View {
        NavigationView {
            VStack{
                if isOnboardingViewActive { /*Not Created Account*/
                  SetUpScreen()
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                } else if isSignedIn && !verified{ /* Email Not Verified */
                  EmailScreen()
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                } else if isSignedIn && verified && !agreedToTerms{ /*Not Agreed To Terms*/
                  TermsConditionsScreen()
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                }
            }
        }
        
    }
}

struct OnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreen()
    }
}
