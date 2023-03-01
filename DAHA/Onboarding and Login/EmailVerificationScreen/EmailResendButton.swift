//
//  EmailResendButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/28/23.
//

import SwiftUI

struct EmailResendButton: View {
    
    @AppStorage("email") var email_system: String = ""
    @Binding var error_alert: Bool
    @Binding var error_message: String
    @EnvironmentObject var authentication: AuthManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: {
            LightFeedback()
            let _ = authentication.sendVerificationEmail()
//            if !result{
//                error_alert = true
//            }
        }){
            ZStack {
                // Blue Button background
                RoundedRectangle(cornerRadius: 33)
                    .fill(Color.init(hex: deepBlue))
                    .frame(width: 180, height: 55)
                    .overlay(Capsule().stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
            
                HStack {
                    // Continue Text
                    Text("RESEND EMAIL")
                        .font(
                            .system(size:20, weight: .bold)
                        )
                        .foregroundColor(.white)
                        .padding(3)
                } //: HStack
            } //: ZStack
        }
    }
}

struct EmailResendButton_Previews: PreviewProvider {
    static var previews: some View {
        EmailResendButton(error_alert: .constant(false), error_message: .constant(""))
    }
}
