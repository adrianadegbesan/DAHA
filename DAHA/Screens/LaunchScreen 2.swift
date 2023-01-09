//
//  LaunchScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        ZStack {
            BackgroundColor(color: "E8E8E8")
            VStack {
                Image("Logo")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Spacer().frame(height: 25)
                Text("DOES ANYONE HAVE A...?")
                    .titleText()
                Spacer().frame(height: 60)
            } //: VStack
        } //: ZStack
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
            .previewLayout(.sizeThatFits)
    }
}
