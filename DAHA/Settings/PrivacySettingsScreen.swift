//
//  PrivacySettingsScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/22/23.
//

import SwiftUI

struct PrivacySettingsScreen: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack{
            Image("Logo")
                .overlay(Rectangle().stroke(colorScheme == .dark ? .white : .clear, lineWidth: 2))
                .padding(.bottom, 20)
            Text("Privacy Policy")
                .titleText()
            VStack(spacing: 0){
                PageBottomDivider()
                    .padding(.horizontal, 15)
                ScrollView{
                    VStack(alignment: .leading){
                        Text(privacyPolicyText)
                            .font(.body)
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

struct PrivacySettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        PrivacySettingsScreen()
    }
}
