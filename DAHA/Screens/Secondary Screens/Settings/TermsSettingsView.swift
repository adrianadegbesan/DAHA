//
//  TermsSettingsView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/14/23.
//

import SwiftUI

struct TermsSettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var shouldNavigate : Bool
    
    var body: some View {
        Button(action:{
            shouldNavigate = true
        }){
            VStack(alignment: .leading){
                HStack{
                    HStack{
                        Text(Image(systemName: "newspaper"))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        Spacer()
                    }
                    .frame(width: screenWidth * 0.1)
                   
                    Text("Terms & Conditions")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
                Divider()
            }
        }
    }
}

struct TermsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsSettingsView(shouldNavigate: .constant(false))
    }
}
