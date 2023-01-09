//
//  SavedScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

// Saved Screen
struct SavedScreen: View {
    var body: some View {
        ZStack {
            BackgroundColor(color: greyBackground)
            VStack {
                HeaderView(title: "Saved", showMessages: false, showSettings: false)
                .frame(alignment: .top)
                Spacer()
            } //: VStack
        } //: ZStack
    }
}

struct SavedScreen_Previews: PreviewProvider {
    static var previews: some View {
        SavedScreen()
    }
}
