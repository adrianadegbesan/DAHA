//
//  ContinueButton.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 1/7/23.
//

import SwiftUI

struct FirstContinueButton: View {
    
    @Binding var schoolFound: Bool
    @Binding var isPresented: Bool
    @Binding var email: String
    @Binding var shouldNavigate: Bool
    @Binding var domain: String
    @State private var showAlert_noemail : Bool = false
    @State private var showAlert_invalidemail : Bool = false
    @State private var cannot_verify : Bool = false
    @State private var uni_temp : String = ""
    @State var isValid : Bool = false
    @AppStorage("university") var university: String = ""
    @AppStorage("email") var email_system: String = ""
    @EnvironmentObject var firestoreManager : FirestoreManager
    @EnvironmentObject var authentication: AuthManager
    @Environment(\.colorScheme) var colorScheme

    
    var body: some View {
        Button(action: {
            LightFeedback()
            isValid = isValidEmailAddress(emailAddressString: email)
            domain = getDomain(email: email)
            
            //Empty Email Check
            if (email.trimmingCharacters(in: .whitespaces).isEmpty){
                showAlert_noemail = true
            }
            //Valid Email Check
            else if !isValid{
                showAlert_invalidemail = true
            }
             else {
                 Task {
                     //Verify domain
                     await firestoreManager.verifyDomain(domain: domain, schoolFound: $schoolFound, cannot_verify: $cannot_verify, uni_temp: $uni_temp)
                     if schoolFound == true {
                         university = uni_temp
                         email_system = email
                         print("The university is \(university)")
                         shouldNavigate = true
                     } else {
                         isPresented = true
                     }
                 }
            }
           
        } ) {
            ZStack {
                // Blue Button background
                RoundedRectangle(cornerRadius: 33)
                    .fill(Color.init(hex: deepBlue))
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
        } //: Button
        .alert("No Email Provided", isPresented: $showAlert_noemail, actions: {}, message: { Text("Please enter an email address")})
        .alert("Invalid Email Provided", isPresented: $showAlert_invalidemail, actions: {}, message: { Text("Please enter a valid email address")})
        .alert("Cannot Verify Email Address", isPresented: $cannot_verify, actions: {}, message: {Text("Cannot verify email address, please check your network connection and try again later")})
    }
}

struct ContinueButton_Previews: PreviewProvider {
    static var previews: some View {
        FirstContinueButton(schoolFound: .constant(false), isPresented: .constant(false), email: .constant("team@joindaha.com"), shouldNavigate: .constant(false), domain: .constant(""))
            .previewLayout(.sizeThatFits)
            .environmentObject(FirestoreManager())
            .environmentObject(AuthManager())
    }
}
