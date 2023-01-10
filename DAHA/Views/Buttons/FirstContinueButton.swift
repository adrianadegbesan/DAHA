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
    @State var isValid : Bool = false
    @EnvironmentObject var firestoreManager : FirestoreManager

    
    var body: some View {
        Button(action: {
            isValid = isValidEmailAddress(emailAddressString: email)
            domain = getDomain(email: email)
            
            if (email.isEmpty || email.trimmingCharacters(in: .whitespaces).isEmpty){
                showAlert_noemail = true
            }
            else if !isValid{
                showAlert_invalidemail = true
            }
             else {
                 Task {
                     await firestoreManager.verifyDomain(domain: domain, schoolFound: $schoolFound, cannot_verify: $cannot_verify)
                     if schoolFound == true {
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
        .alert("No Email Provided", isPresented: $showAlert_noemail, actions: {}, message: { Text("Please input an email address")})
        .alert("Invalid Email Provided", isPresented: $showAlert_invalidemail, actions: {}, message: { Text("Please input a valid email address")})
        .alert("Cannot Verify Email Address", isPresented: $cannot_verify, actions: {}, message: {Text("Cannot verify email address, please check your network connection and try again later")})

    }
}

struct ContinueButton_Previews: PreviewProvider {
    static var previews: some View {
        FirstContinueButton(schoolFound: .constant(false), isPresented: .constant(false), email: .constant("adrian25@stanford.edu"), shouldNavigate: .constant(false), domain: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}
