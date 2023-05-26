//
//  LoginButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

struct LoginButton: View {
    @State private var shouldNavigate = false
    var body: some View {
        Button(action: {
            LightFeedback()
            shouldNavigate = true
            
        }) {
            Text("LOGIN")
                    .font(
                        .system(size:30, weight: .bold)
                    )
                .foregroundColor(Color.init(hex: darkGrey))
            NavigationLink(destination: LoginScreen(), isActive: $shouldNavigate){
                EmptyView()
            }
        }
    }
}

struct LoginButton_Previews: PreviewProvider {
    static var previews: some View {
        LoginButton()
    }
}
