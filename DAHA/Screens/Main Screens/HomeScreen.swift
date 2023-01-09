//
//  HomeScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

// Home Screen
struct HomeScreen: View {
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = false
    
    var body: some View {
            ZStack {
                BackgroundColor(color: greyBackground)
                VStack {
                    HeaderView(title: "Stanford", showMessages: true, showSettings: false)
                        .frame(alignment: .top)
                        Spacer()
                        Button(action: {isOnboardingViewActive = true}, label: {
                            Text("Log Out")
                                .font(.system(size:20, weight: .bold))
                    }) //: Button
                        .padding()
                } //: VStack
            } //: ZStack
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
