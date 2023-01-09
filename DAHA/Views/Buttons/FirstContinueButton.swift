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
    @State var isValid : Bool = false

    
    var body: some View {
        Button(action: {
            isValid = isValidEmailAddress(emailAddressString: email)
            domain = getDomain(email: email)
//            schoolFound = firestoreManager.verifyDomain(domain: domain)
            
            if (email.isEmpty || email.trimmingCharacters(in: .whitespaces).isEmpty){
                showAlert_noemail = true
            }
            else if !isValid{
                showAlert_invalidemail = true
            }
            else if !schoolFound {
                isPresented = true
            } else {
                shouldNavigate = true
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

    }
}

struct ContinueButton_Previews: PreviewProvider {
    static var previews: some View {
        FirstContinueButton(schoolFound: .constant(false), isPresented: .constant(false), email: .constant("adrian25@stanford.edu"), shouldNavigate: .constant(false), domain: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}
