//
//  EmailVerificationScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/8/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct EmailVerificationScreen: View {
    
    @Binding var email: String
    @State private var error_alert : Bool = false
    @State private var error_message : String = ""
    @State private var should_navigate : Bool = false
    @State private var code : String = ""
    @State private var text_code : String = ""
    @State private var incorrect_code : Bool = false
    @EnvironmentObject var authentication: AuthManager
    @AppStorage("email") var email_system: String = ""
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack{
            ScrollView{
                Image("Logo")
                    .overlay(Rectangle().stroke(colorScheme == .dark ? .white : .clear, lineWidth: 2))
                Spacer().frame(height: screenHeight * 0.2)
                Text("Please enter the verification code we just sent to your email:")
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)
                    .font(.system(size: 18, weight: .black))
                TextField("Code", text: $text_code)
                    .keyboardType(.numberPad)
                    .onChange(of: text_code){ value in
                        if text_code.count < 6 {
                            incorrect_code = false
                        }
                        if text_code == code && code != ""{
                            email_system = email.trimmingCharacters(in: .whitespaces)
                            should_navigate = true
                        }
                        if text_code.count > 6 || (text_code.count == 6 && text_code != code){
                            incorrect_code = true
                        }
                    }
                    .padding(.horizontal, 150)
                Divider()
                    .padding(.horizontal, 150)
                    .frame(height: 4)
                    .overlay(Color(hex: incorrect_code ? red_color : deepBlue).padding(.horizontal, 150))
                Spacer().frame(height: 20)
                ResendButton(email: email, error_alert: $error_alert, error_message: $error_message, code: $code)
                    .padding(.bottom, 40)
            } //: VStack
        } //: ZStack
        .keyboardControl()
        .onAppear{
            Task {
                code = String(await sendVerificationEmail(email: email, error_alert: $error_alert, error_message: $error_message) )
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .alert("Error Verifying Email", isPresented: $error_alert, actions: {}, message: { Text("Error Verifying email, please check your network connection and try again later")})
        
        NavigationLink(destination: CreateAccountScreen().navigationBarBackButtonHidden(true), isActive: $should_navigate){
            EmptyView()
        }
        

    }
}


struct EmailVerificationScreen_Previews: PreviewProvider {
    static var previews: some View {
        EmailVerificationScreen(email: .constant("adrian25@stanford.edu"))
            .environmentObject(AuthManager())
    }
}
