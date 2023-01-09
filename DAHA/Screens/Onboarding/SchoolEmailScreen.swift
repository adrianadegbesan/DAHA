//
//  SchoolEmailScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

struct SchoolEmailScreen: View {
    
    @State private var email : String = " "
    @State private var schoolFound : Bool = true
    @State private var isPresented : Bool = false
    @State private var shouldNavigate : Bool = false
    
    var body: some View {
        ZStack {
            BackgroundColor(color: greyBackground)
            VStack {
                Image("Logo")
                Spacer()

                Text("MY SCHOOL EMAIL IS ...")
                    .font(.system(size: 26, weight: .black))
                CustomInputField(imageName: "envelope", placeholderText: "EMAIL (.edu)", text: $email, secure: false)
                    .padding(.horizontal, 40)
                Text("Your email is only used to authenticate your school affiliation. DAHA is NOT affiliated with any institution")
                    .font(.system(size: 12, weight: .light))
                    .padding(.horizontal, 40)
              
                Spacer().frame(height: screenHeight * 0.3)
                ContinueButton(schoolFound: $schoolFound, isPresented: $isPresented, email: $email, shouldNavigate: $shouldNavigate)
                    .padding(.bottom, 20)

                NavigationLink(destination: CreateAccountScreen(), isActive: $shouldNavigate){
                    EmptyView()
                }
            } //: VStack
        }//: ZStack
        .sheet(isPresented: $isPresented){
            UniversityNotFoundView(email: $email, isPresented: $isPresented)
        }
        
    }
}

struct SchoolEmailScreen_Previews: PreviewProvider {
    static var previews: some View {
        SchoolEmailScreen()
    }
}

