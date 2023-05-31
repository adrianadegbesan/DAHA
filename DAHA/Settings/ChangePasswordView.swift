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
    @State private var selected : Bool = false
    @State private var changing : Bool = false
   
    var body: some View {
        
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
            .onTapGesture {
                withAnimation{
                    selected.toggle()
                }
            }
            .alert("Error Changing Password", isPresented: $error_alert, actions: {}, message: {Text(error_message)})
            .alert("Password Changed", isPresented: $success_alert, actions: {}, message: {Text("Your password was successfully changed!")})
           
            if selected{
                
                HStack{
                    VStack{
                        SecureField("Current Password", text: $password)
                            .padding(10)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(colorScheme == .dark ? .white : .black , lineWidth: 2))
                            .foregroundColor(Color(hex: deepBlue))
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 5)
                            .padding(.bottom, 8.5)
                            .textContentType(.password)
                    
                        SecureField("New Password", text: $newPassword)
                            .padding(10)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(colorScheme == .dark ? .white : .black , lineWidth: 2))
                            .foregroundColor(Color(hex: deepBlue))
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 5)
                            .textContentType(.newPassword)
                    }
                }
                .padding([.top, .bottom], 5)
                
               
                HStack{
                    Spacer()
                    Button(action: {
                        SoftFeedback()
                        changing = true
                        Task {
                            let success = await authentication.changePassword(password: $password, newPassword: $newPassword, error_message: $error_message)
                            changing = false
                            if success{
                                success_alert = true
                                password = ""
                                newPassword = ""
                            } else {
                                error_alert = true
                            }
                        }
                    }){
                        if !changing{
                            Text("Change")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding(6.5)
                                .background(Capsule().fill(Color(hex: deepBlue)))
                                .overlay(Capsule().stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
                                .scaleEffect(0.9)
                                .padding([.top, .bottom], 5)
                        } else {
                            ProgressView()
                        }
                       
                    }
                    .buttonStyle(.plain)
                    .disabled(changing)
                }
            }
     
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
