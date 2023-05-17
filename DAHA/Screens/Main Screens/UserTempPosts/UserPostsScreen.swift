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
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "@\(username)", showMessages: false, showSettings: false, showSearchBar: false, slidingBar: false, tabIndex: nil, tabs: nil, screen: "UserTemp")
                .frame(alignment: .top)
            Divider()
            TabView(){
                UserTempPosts(userId: userId)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            Divider()
        } //: VStack
        .frame(width: screenWidth)
    }
}

struct UserPostsScreen_Previews: PreviewProvider {
    static var previews: some View {
        let username = "adrian"
        let userId = "12345"
        UserPostsScreen(username: username, userId: userId)
    }
}
