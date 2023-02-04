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
    @State var shouldNavigate : Bool = false
    
    var body: some View {
            ZStack {
                BackgroundColor(color: greyBackground)
                VStack(spacing: 0) {
                    HeaderView(title: university, showMessages: true, showSettings: false, showSearchBar: true)
                        .frame(alignment: .top)
                    Spacer()
                        ScrollView{
                            ProgressView()
                                
                        }
                        .refreshable {

                        }
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
//
                VStack{
                    PostButton()
                    .offset(x: screenWidth * 0.35, y: screenHeight * 0.325)
                }
                
                NavigationLink(destination: MakePostScreen(), isActive: $shouldNavigate){
                    EmptyView()
                }
                
            } //: ZStack
            .navigationBarBackButtonHidden(true)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
            HomeScreen()
    }
}
