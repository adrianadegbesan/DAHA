//
//  TermsConditionsScreen.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/1/23.
//

import SwiftUI

struct TermsConditionsScreen: View {
    
    @State private var toggle : Bool = false
    @State private var shouldNavigate : Bool = false
    @State private var isAnimating : Bool = false
    @AppStorage("termsagreed") var agreedToTerms: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authentication : AuthManager
    @EnvironmentObject var appState : AppState
     
    var body: some View {
        VStack{
            Spacer().frame(height: screenHeight * 0.025)
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
                .padding(.bottom, 20)
            Text("Terms and Conditions")
                .titleText()
            VStack(spacing: 0){
                Divider()
                ScrollView{
                    Spacer().frame(height: 10)
                    VStack(alignment: .leading){
                        Text(termsAndConditionsText)
                            .font(.body)
                    }
                }
                .padding(.horizontal, 15)
                Divider()
            }
            HStack{
                Image(systemName: toggle ? "checkmark.square.fill" : "square")
                    .scaleEffect(1.3)
                    .foregroundColor(toggle ? Color(hex: deepBlue): .secondary)
                    .onTapGesture {
                        withAnimation{
                            toggle.toggle()
                        }
                    }
                Text("I agree to these terms and conditions")
                    .font(
                        .system(size:15, weight: .bold)
                    )
                  
            }
            Button(action: {
                if toggle {
                    LightFeedback()
//                    agreedToTerms = true
                    Task{
                        _ = await authentication.hasAgreedToTerms()
//                        if success {
//                            agreedToTerms = true
//                            shouldNavigate = true
//                        } else {
//                            agreedToTerms = true
//                            shouldNavigate = true
//                        }
                        appState.firstSignOn = true
                        agreedToTerms = true
                    }
                } 
            }){
                ZStack {
                    // Blue Button background
                    RoundedRectangle(cornerRadius: 33)
                        .fill(toggle ? Color.init(hex: deepBlue) : .gray)
                        .frame(width: 180, height: 55)
                        .overlay(Capsule().stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
                    
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
            .buttonStyle(.plain)
            NavigationLink(destination: MainScreen().navigationBarHidden(true), isActive: $shouldNavigate){
                EmptyView()
            }
            .buttonStyle(.plain)
        }
    }
}

struct TermsConditionsScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TermsConditionsScreen()
                .environmentObject(AuthManager())
        }
    }
}
