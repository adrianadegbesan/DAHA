//
//  UserPostsScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 5/16/23.
//

import SwiftUI

struct UserPostsScreen: View {
    
    @State var username : String
    @State var userId : String
    @EnvironmentObject var firestoreManager : FirestoreManager
    @State var opacity = 0.0
    @State var show: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "@\(username)", showMessages: false, showSettings: false, showSearchBar: false, slidingBar: false, tabIndex: nil, tabs: nil, screen: "UserTemp")
                .frame(alignment: .top)
            Divider()
            if show {
                
                ScrollView{
                    PostShimmerScroll()
                        .padding(.top, 15)
                }
                
            } else {
                TabView() {
                    UserTempPosts(userId: userId)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            Divider()
        } //: VStack
        .frame(width: screenWidth)
        .navigationTitle("")
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.65){
                withAnimation {
                    show = false
                }
            }
        }
    }
}

struct UserPostsScreen_Previews: PreviewProvider {
    static var previews: some View {
        let username = "adrian"
        let userId = "12345"
        UserPostsScreen(username: username, userId: userId)
    }
}
