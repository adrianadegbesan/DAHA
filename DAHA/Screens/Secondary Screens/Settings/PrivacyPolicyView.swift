//
//  PrivacyPolicyView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/22/23.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var shouldNavigate : Bool

    var body: some View {
        Button(action:{
            shouldNavigate = true
        }){
            VStack(alignment: .leading){
                HStack{
                    HStack{
                        Text(Image(systemName: "person.badge.key.fill"))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        Spacer()
                    }
                    .frame(width: screenWidth * 0.1)
                   
                    Text("Privacy Policy")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
            }
        }
    }
}

struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicyView(shouldNavigate: .constant(false))
    }
}
