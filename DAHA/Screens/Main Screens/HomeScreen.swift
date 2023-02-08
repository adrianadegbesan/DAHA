//
//  HomeScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI
import Firebase

// Home Screen
struct HomeScreen: View {
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = false
    @AppStorage("signedin") var isSignedIn: Bool = false
    @AppStorage("university") var university: String = ""
    @State var shouldNavigate : Bool = false

    
//    let post = PostModel(title: "2019 Giant Bike", userID: "0", username: "adrian", description: "Old Bike for sale, very very very old but tried and trusted, gave me alot of miles but kinda creaky sometimes", postedAt: nil, condition: "Good", category: "Bikes", price: "100", imageURLs: [], channel: "Stanford", savers: [])
    
    var body: some View {
            ZStack {
                VStack(spacing: 0) {
                    HeaderView(title: university, showMessages: true, showSettings: false, showSearchBar: true)
                        .frame(alignment: .top)
//                    Spacer()
                        ScrollView{
//                            PostView(post: post, owner: false)
//                                .padding(.top, 10)
                        }
                        .refreshable {

                        }
                    Spacer()
    
                    
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
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(action: {
                        hideKeyboard()
                    }){
                            Text(Image(systemName: "multiply"))
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
            HomeScreen()
    }
}
