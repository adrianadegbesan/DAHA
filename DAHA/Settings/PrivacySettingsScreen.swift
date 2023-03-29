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
                Divider()
                ScrollView{
                    Spacer().frame(height: 10)
                    VStack(alignment: .leading){
                        Text(privacyPolicyText)
                            .font(.body)
                    }
                }
                .padding(.horizontal, 15)
                Divider()
            }
        }
    }
}

struct PrivacySettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        PrivacySettingsScreen()
    }
}
