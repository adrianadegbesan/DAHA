//
//  TermsSettingsView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/14/23.
//

import SwiftUI

struct TermsSettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationLink(destination: TermsSettingsScreen()){
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
        TermsSettingsView()
    }
}
