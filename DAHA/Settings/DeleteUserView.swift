//
//  DeleteUserView.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/14/23.
//

import SwiftUI

struct DeleteUserView: View {
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = false
    @AppStorage("signedin") var isSignedIn: Bool = true
    @AppStorage("termsagreed") var agreedToTerms: Bool = true
    @AppStorage("university") var university: String = ""
    @AppStorage("username") var username_system: String = ""
    @AppStorage("email") var email_system: String = ""
    @AppStorage("isDarkMode") private var isDarkMode = "System"
    @AppStorage("emailverified") var verified: Bool = true
    
    @State private var firstPresented = false
    @State private var isPresented = false
    @State private var error_alert = false
    @State private var error_message = ""
    @State private var password = ""
    @State private var selected = false
    @State private var changing : Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authentication : AuthManager
    
    var body: some View {
            VStack(alignment: .leading){
                HStack {
                    HStack {
                        Image(systemName: "trash.circle")
                            .foregroundColor(.red)
                        Spacer()
                    }
                    .frame(width: screenWidth * 0.1)
                    Text("Delete Account")
                        .foregroundColor(.red)
                }
            }
                .onTapGesture {
                    withAnimation{
                        selected.toggle()
                    }
                }
                .alert("Delete Account", isPresented: $isPresented, actions: {
                    Button("Delete", role: .destructive, action: {
                        Task {
                            let success = await authentication.deleteUser()
                            if success {
                                isOnboardingViewActive = true
                                isSignedIn = false
                                agreedToTerms = false
                                university = ""
                                username_system = ""
                                email_system = ""
                                isDarkMode = "System"
                                verified = false
                            } else {
                                error_message = "Please check your network connection and try again later"
                                print("failed")
                                error_alert = true
                            }
                        }
                    })
                }, message: { Text("Are you sure you want to delete your account? This action cannot be reversed.")})
                .alert("Error Deleting Account", isPresented: $error_alert, actions: {}, message: {Text(error_message)})
               
                if selected{
                    
                    HStack{
                        VStack{
                            SecureField("Password", text: $password)
                                .padding(10)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(colorScheme == .dark ? .white : .black , lineWidth: 2))
                                .foregroundColor(Color(hex: deepBlue))
                                .padding(.horizontal, 5)
                                .textContentType(.password)
                        }
                    }
                    .padding([.top, .bottom], 5)
                    HStack{
                        Spacer()
                        VStack {
                            Button(action: {
                                SoftFeedback()
                                changing = true
                                Task {
                                    let success = await authentication.reauthenticate(password: $password, error_message: $error_message)
                                    changing = false
                                    if success {
                                         isPresented = true
                                    } else {
                                        error_alert = true
                                    }
                                }
                            }){
                                if !changing{
                                    Text("Delete")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .padding(6.5)
                                        .background(Capsule().fill(.red))
                                        .overlay(Capsule().stroke(colorScheme == .dark ? .white : .black, lineWidth: 2))
                                        .scaleEffect(0.9)
                                        .padding([.top, .bottom], 5)
                                } else {
                                    ProgressView()
                                }
                            
                            }
                            .disabled(changing)
                        }
                    }
                }
            }
         
         
    }


struct DeleteUserView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteUserView()
    }
}
