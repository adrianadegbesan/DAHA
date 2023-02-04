//
//  TermsConditionsScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/1/23.
//

import SwiftUI

struct TermsConditionsScreen: View {
    
    @State var toggle : Bool = false
    @State var shouldNavigate : Bool = false
    @AppStorage("termsagreed") var agreedToTerms: Bool = false
    
    var body: some View {
        VStack{
            Image("Logo")
                .padding(.bottom, 20)
            Text("Terms and Conditions")
                .titleText()
            VStack(spacing: 0){
                PageBottomDivider()
                    .padding(.horizontal, 15)
                ScrollView{
                    VStack(alignment: .leading){
                        Text("Terms")
                            .frame(alignment: .leading)
                    }
                }
                .padding(.horizontal, 15)
                PageBottomDivider()
                    .padding(.horizontal, 15)
                    .padding(.bottom, 15)
            }
            HStack{
                Image(systemName: toggle ? "checkmark.square.fill" : "square")
                    .scaleEffect(1.3)
                    .foregroundColor(toggle ? Color(hex: deepBlue): .secondary)
                    .onTapGesture {
                        toggle.toggle()
                    }
                Text("I agree to these terms and conditions")
                    .font(
                        .system(size:15, weight: .bold)
                    )
                  
            }
            Button(action: {
                if toggle {
                    LightFeedback()
                    agreedToTerms = true
                    shouldNavigate = true
                } 
            }){
                ZStack {
                    // Blue Button background
                    RoundedRectangle(cornerRadius: 33)
                        .fill(toggle ? Color.init(hex: deepBlue) : .gray)
                        .frame(width: 180, height: 55)
                    
                    HStack {
                        // Continue Text
                        Text("CONTINUE")
                            .font(
                                .system(size:20, weight: .bold)
                            )
                            .foregroundColor(.white)
                            .padding(3)
                    } //: HStack
                } //: ZStack
                .padding(.bottom, 60)
            }
            
            NavigationLink(destination: MainScreen().navigationBarHidden(true), isActive: $shouldNavigate){
                EmptyView()
            }
        }
    }
}

struct TermsConditionsScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TermsConditionsScreen()
        }
    }
}
