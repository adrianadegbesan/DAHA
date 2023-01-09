//
//  SchoolEmailScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

struct SchoolEmailScreen: View {
    
    @State private var email : String = " "
    @State private var schoolFound : Bool = false
    @State private var isPresented : Bool = false
    
    var body: some View {
        ZStack {
            BackgroundColor(color: greyBackground)
            VStack {
                Image("Logo")
                Spacer()
                Text("MY SCHOOL EMAIL IS ...")
                    .font(.system(size: 26, weight: .black))
                TextField(" EMAIL (.edu)", text: $email)
                    .inputFields()
                Text("Your email is only used to authenticate your school affiliation. DAHA is NOT affiliated with any institution")
                    .font(.system(size: 12, weight: .light))
                    .padding(.horizontal, 40)
                Spacer()
                ContinueButton(schoolFound: $schoolFound, isPresented: $isPresented)
                    .padding(.bottom, 25)
            } //: VStack
        }//: ZStack
        .sheet(isPresented: $isPresented){
            UniversityNotFoundView(email: $email)
        }
    }
}

struct SchoolEmailScreen_Previews: PreviewProvider {
    static var previews: some View {
        SchoolEmailScreen()
    }
}

