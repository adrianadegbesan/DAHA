//
//  AuthViewModel.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/11/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

class AuthManager: ObservableObject {
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true
    @Published var userSession: FirebaseAuth.User?
    
    init(){
        self.userSession = Auth.auth().currentUser
        if (self.userSession != nil){
            print("DEBUG: The current User Session is \(self.userSession!)")
        } else {
            print("DEBUG: The current User Session is nil")
        }
        
        if (self.userSession == nil) {
            isOnboardingViewActive = true
        }
    }
    
    
    
    
}
