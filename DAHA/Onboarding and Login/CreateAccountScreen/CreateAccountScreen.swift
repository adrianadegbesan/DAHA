//
//  CreateAccountScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/8/23.
//

import SwiftUI
import Firebase

struct CreateAccountScreen: View {
    
        @State private var firstname : String = ""
        @State private var lastname : String = ""
        @State private var username : String = ""
        @State private var password : String = ""
        @State private var reconfirmPassword : String = ""
        @State private var shouldNavigate : Bool = false
        @State private var error : Bool = false
        @State private var error_message : String = ""
        @State var uploading : Bool = false
        @State var progressOpacity = 0.0
        @State var screenOpacity = 1.0
        @EnvironmentObject var firestoreManager : FirestoreManager
        @Environment(\.colorScheme) var colorScheme
         
        var body: some View {
            ZStack {
                ProgressView()
                    .opacity(progressOpacity)
                    .scaleEffect(2.5)
                ScrollView {
                    Image("Logo")
                        .overlay(Rectangle().stroke(colorScheme == .dark ? .white : .clear, lineWidth: 2))
                    Spacer().frame(height: 0.09 * screenHeight)
                    Text(" CREATE ACCOUNT ")
                        .font(.system(size: 26, weight: .black))
                        .padding()
                    HStack{
                        CustomInputField(imageName: nil, placeholderText: "FIRST NAME", text: $firstname, secure: false)
                            .padding(.trailing, 20)
                        
                        CustomInputField(imageName: nil, placeholderText: "LAST NAME", text: $lastname, secure: false)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                    
                    CustomInputField(imageName: nil, placeholderText: "USERNAME", text: $username, secure: false)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 30)
                    
                    CustomInputField(imageName: nil, placeholderText: "PASSWORD", text: $password, secure: true)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 30)
                    
                    CustomInputField(imageName: nil, placeholderText: "CONFIRM PASSWORD", text: $reconfirmPassword, secure: true)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 30)
                    
                    
                    Spacer().frame(height: screenHeight * 0.18)
                    
                    SecondContinueButton(firstName: $firstname, lastName: $lastname, username: $username, password: $password, reconfirm_password: $reconfirmPassword, error: $error, error_message: $error_message, uploading: $uploading)
                        .padding(.bottom, 20)

                    NavigationLink(destination: MainScreen(), isActive: $shouldNavigate){
                        EmptyView()
                    }
                } //: ScrollView
                .opacity(screenOpacity)
                .disabled(uploading)
            }//: ZStack
            .keyboardControl()
            .onAppear{
                print( Auth.auth().currentUser ?? "nil")
            }
            .onTapGesture {
                hideKeyboard()
            }
            .onChange(of: uploading) { value in
                if uploading {
                    screenOpacity = 0.5
                    progressOpacity = 1.0
                } else if !uploading {
                    screenOpacity = 1.0
                    progressOpacity = 0.0
                }
            }
            .alert("Error Creating Account", isPresented: $error, actions: {}, message: {Text(error_message)} )
           }
        }


struct CreateAccountScreen_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountScreen()
            .environmentObject(FirestoreManager())
            .environmentObject(AuthManager())
    }
}
