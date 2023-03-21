//
//  ChangePasswordView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/18/23.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State private var isPresented = false
    @State private var password = ""
    @State private var newPassword = ""
    @State private var error_message : String = ""
    @State private var error_alert: Bool = false
    @State private var success_alert: Bool = false
    @EnvironmentObject var authentication : AuthManager
   
    var body: some View {
        
        Button(action: {
            
            isPresented = true
        }){
            VStack(alignment: .leading) {
                HStack {
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        Spacer()
                    }
                    .frame(width: screenWidth * 0.1)
                    
                    Text("Change Password")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
//                Divider()
            }
        }
        .alert("Change Password", isPresented: $isPresented, actions: {
            SecureField("Current Password", text: $password)
                .foregroundColor(Color(hex: deepBlue))
            SecureField("New Password", text: $newPassword)
                .foregroundColor(Color(hex: deepBlue))
            
            Button("Change", action: {
                
                Task {
                    let success = await authentication.changePassword(password: $password, newPassword: $newPassword, error_message: $error_message)
                    if success{
                        success_alert = true
                    } else {
                        error_alert = true
                    }
                }
                
            })
            Button("Cancel", role: .cancel, action: {})
            
        })
        .alert("Error Changing Password", isPresented: $error_alert, actions: {}, message: {Text(error_message)})
        .alert("Password Changed", isPresented: $success_alert, actions: {}, message: {Text("Your password was successfully changed!")})
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
