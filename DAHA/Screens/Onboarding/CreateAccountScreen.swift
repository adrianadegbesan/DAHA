//
//  CreateAccountScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/8/23.
//

import SwiftUI
import Firebase

struct CreateAccountScreen: View {
    
        @AppStorage("onboarding") var isOnboardingViewActive: Bool = false
        @State private var firstname : String = ""
        @State private var lastname : String = ""
        @State private var username : String = ""
        @State private var password : String = ""
        @State private var reconfirmPassword : String = ""
        @State private var shouldNavigate : Bool = false
        @State private var error : Bool = false
        @State private var error_message : String = ""
    

        
        @EnvironmentObject var firestoreManager : FirestoreManager
        
        var body: some View {
            ZStack {
                BackgroundColor(color: greyBackground)
                ScrollView {
                    Image("Logo")
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
                    
                    SecondContinueButton(firstName: $firstname, lastName: $lastname, username: $username, password: $password, reconfirm_password: $reconfirmPassword, error: $error, error_message: $error_message)
                        .padding(.bottom, 20)

                    NavigationLink(destination: MainScreen(), isActive: $shouldNavigate){
                        EmptyView()
                    }
                } //: VStack
            }//: ZStack
            .onAppear{
                print( Auth.auth().currentUser ?? "nil")
                if( Auth.auth().currentUser == nil){
                    isOnboardingViewActive = true
                }
                isOnboardingViewActive = false
            }
            .alert("Error Creating Account", isPresented: $error, actions: {}, message: {Text(error_message)} )
           }
        }


struct CreateAccountScreen_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountScreen()
    }
}
