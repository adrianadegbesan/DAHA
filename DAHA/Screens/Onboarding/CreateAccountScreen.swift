//
//  CreateAccountScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/8/23.
//

import SwiftUI

struct CreateAccountScreen: View {
    
        @State private var firstname : String = ""
        @State private var lastname : String = ""
        @State private var username : String = ""
        @State private var password : String = ""
        @State private var confirmpassword : String = ""
        @State private var shouldNavigate : Bool = false
        
        var body: some View {
            ZStack {
                BackgroundColor(color: greyBackground)
                VStack {
                    Image("Logo")
                    Spacer()
                    Text(" CREATE ACCOUNT ")
                        .font(.system(size: 26, weight: .black))
                        .padding()
                    HStack{
                        CustomInputField(imageName: nil, placeholderText: "FIRST NAME", text: $firstname, secure: false)
                        
                        CustomInputField(imageName: nil, placeholderText: " LAST NAME", text: $lastname, secure: false)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                    
                    CustomInputField(imageName: nil, placeholderText: "USERNAME", text: $username, secure: false)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 30)
                    
                    CustomInputField(imageName: nil, placeholderText: "PASSWORD", text: $password, secure: true)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 30)
                    
                    CustomInputField(imageName: nil, placeholderText: "CONFIRM PASSWORD", text: $confirmpassword, secure: true)
                        .padding(.horizontal, 30)
                    
                    
                    Spacer()

                    NavigationLink(destination: MainScreen(), isActive: $shouldNavigate){
                        EmptyView()
                    }
                } //: VStack
            }//: ZStack
            }
            
        }


struct CreateAccountScreen_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountScreen()
    }
}
