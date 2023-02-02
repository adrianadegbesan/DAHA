//
//  ForgotPasswordScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/1/23.
//

import SwiftUI

struct ForgotPasswordScreen: View {
    
    @State var email : String = ""
    
    var body: some View {
        ZStack {
            ScrollView{
                Spacer().frame(height: screenHeight * 0.15)
                Image("Logo")
                    .padding(.bottom, 50)
                
                Text("Forgot Password")
                    .font(
                        .system(size:23, weight: .bold)
                    )
                    .padding(.bottom, 10)
                
                Text("Please enter your DAHA Account Email:")
                    .font(
                        .system(size:17, weight: .bold)
                    )
                    .padding(.bottom, 25)
                
                   
                CustomInputField(imageName: "envelope.fill", placeholderText: "Email", text: $email, secure: false)
                    .padding(.bottom, 50)
                    .padding(.horizontal, screenWidth * 0.2)
                
                PasswordResetButton(email: $email)
            }
            .background(.ultraThinMaterial)
        }
    }
}

struct ForgotPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordScreen()
    }
}