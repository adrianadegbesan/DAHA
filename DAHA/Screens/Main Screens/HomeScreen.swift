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
    @AppStorage("signedin") var isSignedIn: Bool = false
    @AppStorage("university") var university: String = ""
    
    var body: some View {
            ZStack {
                BackgroundColor(color: greyBackground)
                VStack(spacing: 0) {
                    HeaderView(title: university, showMessages: true, showSettings: false)
                        .frame(alignment: .top)
                        ScrollView{
                            ForEach(1..<100){ i in
                                Text("\(i)")
                            }
                        }
                        .background(.ultraThinMaterial)
//                    Spacer()
    
//                        Button(action: {
//                            isOnboardingViewActive = true
//                            isSignedIn = false
//                        }, label: {
//                            Text("Log Out")
//                                .font(.system(size:20, weight: .bold))
//                    }) //: Button
                    PageBottomDivider()
                } //: VStack
            } //: ZStack
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
