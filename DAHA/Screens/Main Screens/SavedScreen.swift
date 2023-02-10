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
            VStack(spacing: 0) {
                HeaderView(title: "Saved", showMessages: false, showSettings: false, showSearchBar: false, slidingBar: false, tabIndex: nil, tabs: nil)
                .frame(alignment: .top)
                Spacer()
                PageBottomDivider()
            } //: VStack
        } //: ZStack
    }
}

struct SavedScreen_Previews: PreviewProvider {
    static var previews: some View {
        SavedScreen()
    }
}
