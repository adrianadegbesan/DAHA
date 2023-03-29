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
                Divider()
                ScrollView{
                    Spacer().frame(height: 10)
                    VStack(alignment: .leading){
                        Text(termsAndConditionsText)
                            .font(.body)
                    }
                }
                .padding(.horizontal, 15)
               Divider()
            }
        }
    }
}

struct TermsSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        TermsSettingsScreen()
    }
}
