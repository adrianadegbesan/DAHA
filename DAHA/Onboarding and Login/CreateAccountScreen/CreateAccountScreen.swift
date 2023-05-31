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
        @State private var uploading : Bool = false
        @State private var progressOpacity = 0.0
        @State private var screenOpacity = 1.0
        @State private var isAnimating : Bool = false
        @EnvironmentObject var firestoreManager : FirestoreManager
        @Environment(\.colorScheme) var colorScheme
         
        var body: some View {
            ZStack {
                if uploading{
                    LottieView(name: colorScheme == .dark ? "DAHA-Loading_dark" : "DAHA-Loading")
                        .scaleEffect(0.35)
                        .opacity(progressOpacity)
                        .padding(.bottom, screenHeight * 0.13)
                        .zIndex(1)
                }
                ScrollView {
                    Spacer().frame(height: 0.045 * screenHeight)
                    Image("Logo")
                        .overlay(Rectangle().stroke(colorScheme == .dark ? .white : .clear, lineWidth: 2))
                        .scaleEffect(isAnimating ? 1.075 : 1.0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1), value: isAnimating)
                        .onTapGesture{
                            if !isAnimating{
                                SoftFeedback()
                                isAnimating = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                   isAnimating = false
                                }
                            }
                         }
                    Spacer().frame(height: 0.06 * screenHeight)
                    Text(" CREATE ACCOUNT ")
                        .font(.system(size: 26, weight: .black))
                        .padding()
                    HStack{
                        CustomInputField(imageName: nil, placeholderText: "FIRST NAME", text: $firstname, secure: false, autocap: true)
                            .padding(.trailing, 20)
                        
                        CustomInputField(imageName: nil, placeholderText: "LAST NAME", text: $lastname, secure: false, autocap: true)
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
                    
                    
                    Spacer().frame(height: screenHeight * 0.07)
                    
                    SecondContinueButton(firstName: $firstname, lastName: $lastname, username: $username, password: $password, reconfirm_password: $reconfirmPassword, error: $error, error_message: $error_message, uploading: $uploading)
                        .padding(.bottom, 20)
                    
                 
                } //: ScrollView
                .opacity(screenOpacity)
                .disabled(uploading)
                
                NavigationLink(destination: EmailScreen().navigationBarBackButtonHidden(true), isActive: $shouldNavigate){
                    EmptyView()
                }
                .buttonStyle(.plain)
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
                    withAnimation{
                        screenOpacity = 0.3
                        progressOpacity = 0.7
                    }
                } else if !uploading {
                    withAnimation{
                        screenOpacity = 1.0
                        progressOpacity = 0.0
                    }
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
