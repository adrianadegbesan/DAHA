//
//  PasswordResetButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/1/23.
//

import SwiftUI

struct PasswordResetButton: View {
    
    @Binding var email: String
    @State private var error_alert: Bool = false
    @State private var success_alert: Bool = false
    @EnvironmentObject var authentication: AuthManager
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        Button(action: {
            LightFeedback()
            //Send password reset email
            authentication.sendPasswordReset(email: email, error_alert: $error_alert, success_alert: $success_alert)
        }){
            ZStack {
                // Blue Button background
                RoundedRectangle(cornerRadius: 33)
                    .fill(Color.init(hex: deepBlue))
                    .frame(width: 160, height: 54)
                    .overlay(Capsule().stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
                
                // Putting Sign Up and Icon side-by-side
                HStack {
                    // Sign Up Text
                    Text("SEND EMAIL")
                        .font(
                            .system(size:20, weight: .bold)
                        )
                        .foregroundColor(.white)
                        .padding(3)
                    
                } //: HStack
            } //: ZStack
        }
        .buttonStyle(.plain)
        .alert("Email Sent!", isPresented: $success_alert, actions: {}, message: { Text("Please check your inbox for a password reset link!")})
        
        .alert("Error sending Email", isPresented: $error_alert, actions: {}, message: { Text("Please check the email you entered and then try again later")})
    }
}

struct PasswordResetButton_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetButton(email: .constant("team@joindaha.com"))
            .environmentObject(AuthManager())
    }
}
