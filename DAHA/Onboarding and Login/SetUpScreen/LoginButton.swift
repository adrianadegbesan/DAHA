//
//  LoginButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

struct LoginButton: View {
    var body: some View {
        NavigationLink(destination: LoginScreen()) {
            Text("LOGIN")
                .font(
                    .system(size:30, weight: .bold)
                )
                .foregroundColor(Color.init(hex: darkGrey))
        }
    }
}

struct LoginButton_Previews: PreviewProvider {
    static var previews: some View {
        LoginButton()
    }
}
