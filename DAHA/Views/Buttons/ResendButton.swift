//
//  ResendButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/11/23.
//

import SwiftUI

struct ResendButton: View {
    
    @State var email: String
    @Binding var error_alert: Bool
    @Binding var error_message: String
    @Binding var code: String
    
    @EnvironmentObject var authentication: AuthManager
    
    var body: some View {
        Button(action: {
            Task {
                code = String(await sendVerificationEmail(email: email, error_alert: $error_alert, error_message: $error_message))
            }
        }){
            ZStack {
                // Blue Button background
                RoundedRectangle(cornerRadius: 33)
                    .fill(Color.init(hex: deepBlue))
                    .frame(width: 180, height: 55)
            
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

struct ResendButton_Previews: PreviewProvider {
    static var previews: some View {
        ResendButton(email: "team@appdaha.com", error_alert: .constant(false), error_message: .constant(""), code:.constant("0123456"))
    }
}
