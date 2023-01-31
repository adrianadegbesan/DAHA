//
//  SearchScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

// Search Screen
struct SearchScreen: View {
    
    var body: some View {
        
        ZStack {
            BackgroundColor(color: greyBackground)
            VStack(spacing: 0) {
                HeaderView(title: "Search", showMessages: false, showSettings: false)
                .frame(alignment: .top)
                Spacer()
                PageBottomDivider()
            } //: VStack
        } //: ZStack
    }
}

struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreen()
    }
}
