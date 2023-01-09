//
//  ProfileScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

// Profile Screen
struct ProfileScreen: View {
    var body: some View {
        ZStack {
            BackgroundColor(color: greyBackground)
            VStack {
                HeaderView(title: "Profile", showMessages: false, showSettings: true)
                .frame(alignment: .top)
                Spacer()
            } //: VStack
        } //: ZStack

    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
