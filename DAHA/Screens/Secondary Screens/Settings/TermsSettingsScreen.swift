//
//  TermsSettingsScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/14/23.
//

import SwiftUI

struct TermsSettingsScreen: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack{
            Image("Logo")
                .overlay(Rectangle().stroke(colorScheme == .dark ? .white : .clear, lineWidth: 2))
                .padding(.bottom, 20)
            Text("Terms and Conditions")
                .titleText()
            VStack(spacing: 0){
                PageBottomDivider()
                    .padding(.horizontal, 15)
                ScrollView{
                    VStack(alignment: .leading){
                        Text("Terms")
                            .frame(alignment: .leading)
                    }
                }
                .padding(.horizontal, 15)
                PageBottomDivider()
                    .padding(.horizontal, 15)
                    .padding(.bottom, 15)
            }
        }
    }
}

struct TermsSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        TermsSettingsScreen()
    }
}
