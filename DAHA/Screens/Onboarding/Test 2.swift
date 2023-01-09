//
//  Test.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

//Test Sign In View for onboarding
struct Test: View {
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true
    
    var body: some View {
        VStack {
            Button(action: {
                isOnboardingViewActive = false}
                ){
                Text("Sign In")
                    .font(.system(size:25, weight: .bold))
            }
            .padding()
        }
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
