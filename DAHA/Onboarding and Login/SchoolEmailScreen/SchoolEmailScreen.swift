//
//  SchoolEmailScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

struct SchoolEmailScreen: View {
    
    @State private var email : String = ""
    @State private var schoolFound : Bool = false
    @State private var isPresented : Bool = false
    @State private var shouldNavigate : Bool = false
    @State private var domain: String = ""
    @EnvironmentObject var firestoreManager : FirestoreManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            ScrollView {
                Image("Logo")
                    .overlay(Rectangle().stroke(colorScheme == .dark ? .white : .clear, lineWidth: 2))
                Spacer().frame(height: screenHeight * 0.2)

                Text("MY SCHOOL EMAIL IS ...")
                    .font(.system(size: 26, weight: .black))
                CustomInputField(imageName: "envelope", placeholderText: "EMAIL (.edu)", text: $email, secure: false)
                    .padding(.horizontal, 40)
                Text("Your email is only used to authenticate your school affiliation. DAHA is NOT affiliated with any institution")
                    .font(.system(size: 12, weight: .light))
                    .padding(.horizontal, 40)
              
                Spacer().frame(height: screenHeight * 0.23)
                FirstContinueButton(schoolFound: $schoolFound, isPresented: $isPresented, email: $email, shouldNavigate: $shouldNavigate, domain: $domain)
                    .padding(.bottom, 20)
                

                NavigationLink(destination: CreateAccountScreen(), isActive: $shouldNavigate){
                    EmptyView()
                }
            } //: VStack
            .ignoresSafeArea(.keyboard)
        }//: ZStack
        .keyboardControl()
        .onTapGesture {
            hideKeyboard()
        }
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $isPresented){
            UniversityNotFoundView(domain: $domain, isPresented: $isPresented)
        }
        
    }
}

struct SchoolEmailScreen_Previews: PreviewProvider {
    static var previews: some View {
        SchoolEmailScreen()
            .environmentObject(FirestoreManager())
    }
}

